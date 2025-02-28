import re
import os
import json
import datetime

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut

LOG_FILE = os.path.expanduser("~/Desktop/kitty_pass_keys.log")

# Cache for vim detection results
_vim_detection_cache = {}
_cache_timeout = 0.5  # Cache results for 0.5 seconds

def log_to_file(message, data=None):
    """Write log messages to the log file with timestamp"""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    with open(LOG_FILE, "a") as f:
        if data:
            try:
                data_str = json.dumps(data, default=str, indent=2)
            except:
                data_str = str(data)
            f.write(f"[{timestamp}] {message}\n{data_str}\n\n")
        else:
            f.write(f"[{timestamp}] {message}\n")

def is_window_vim(window, vim_id):
    fp = window.child.foreground_processes
    log_to_file(f"Checking for vim_id: {vim_id}", {
        "window_id": window.id,
        "window_title": window.title,
        "foreground_processes": fp
    })
    
    # Import subprocess to run ps commands
    import subprocess
    import time
    
    # Optimization 1: Use a single ps command to get all processes at once
    # This avoids multiple subprocess calls
    start_time = time.time()
    
    try:
        # Get all processes in a single call
        cmd = "ps -ax -o pid,ppid,command"
        process_output = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        
        if process_output.returncode != 0:
            log_to_file(f"Error getting process list: {process_output.stderr}")
            return False
            
        # Parse the output into a dictionary for quick lookups
        processes = {}
        children = {}
        
        for line in process_output.stdout.strip().split('\n')[1:]:  # Skip header
            parts = line.strip().split(None, 2)
            if len(parts) >= 3:
                pid, ppid, command = parts
                pid, ppid = pid.strip(), ppid.strip()
                
                # Store process info
                processes[pid] = {
                    'command': command,
                    'ppid': ppid,
                    'is_vim': bool(re.search(vim_id, command, re.I))
                }
                
                # Build child relationships
                if ppid not in children:
                    children[ppid] = []
                children[ppid].append(pid)
        
        # Get all process IDs from foreground processes
        process_ids = [str(p['pid']) for p in fp if 'pid' in p]
        
        # Optimization 2: Use a set for visited PIDs to avoid checking the same process multiple times
        visited = set()
        
        # Optimization 3: Use an iterative approach instead of recursion
        def check_process_tree(start_pid, max_depth=2):
            # Use a queue for breadth-first search
            queue = [(start_pid, 0, 'self')]  # (pid, depth, relation)
            
            while queue:
                pid, depth, relation = queue.pop(0)
                
                if pid in visited:
                    continue
                    
                visited.add(pid)
                
                # Check if this process is vim
                if pid in processes and processes[pid]['is_vim']:
                    log_to_file(f"Found vim in {relation} process {pid}: {processes[pid]['command']}")
                    return True
                
                if depth >= max_depth:
                    continue
                
                # Add parent to queue
                if pid in processes:
                    ppid = processes[pid]['ppid']
                    if ppid != "1" and ppid not in visited:  # Don't check init process
                        queue.append((ppid, depth + 1, 'parent'))
                
                # Add children to queue
                if pid in children:
                    for child_pid in children[pid]:
                        if child_pid not in visited:
                            queue.append((child_pid, depth + 1, 'child'))
            
            return False
        
        # Check each process in the window
        for pid in process_ids:
            if check_process_tree(pid):
                end_time = time.time()
                log_to_file(f"Vim found in process tree of PID {pid} (took {(end_time - start_time)*1000:.2f}ms)")
                return True
        
        end_time = time.time()
        log_to_file(f"Vim not found in any process trees (took {(end_time - start_time)*1000:.2f}ms)")
        return False
        
    except Exception as e:
        log_to_file(f"Error in optimized process tree check: {str(e)}")
        return False

def encode_key_mapping(window, key_mapping):
    log_to_file(f"Encoding key mapping: {key_mapping}")
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    encoded = window.encoded_key(event)
    log_to_file(f"Encoded key: {key_mapping} → {encoded.hex()}")
    return encoded

def main():
    pass

@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    log_to_file("=== pass_keys.py called ===", {
        "args": args,
        "target_window_id": target_window_id
    })
    
    direction = args[1]
    key_mapping = args[2]
    vim_id = args[3] if len(args) > 3 else "n?vim"

    log_to_file(f"Direction: {direction}, Key mapping: {key_mapping}, Vim ID: {vim_id}")
    
    window = boss.window_id_map.get(target_window_id)

    if window is None:
        log_to_file("Window not found!")
        return
    
    # Check cache first
    import time
    current_time = time.time()
    cache_key = f"{target_window_id}:{vim_id}"
    
    if cache_key in _vim_detection_cache:
        cached_result, timestamp = _vim_detection_cache[cache_key]
        if current_time - timestamp < _cache_timeout:
            log_to_file(f"Using cached vim detection result: {cached_result}")
            is_vim = cached_result
        else:
            # Cache expired
            is_vim = is_window_vim(window, vim_id)
            _vim_detection_cache[cache_key] = (is_vim, current_time)
    else:
        # No cache entry
        is_vim = is_window_vim(window, vim_id)
        _vim_detection_cache[cache_key] = (is_vim, current_time)
        
    if is_vim:
        log_to_file("Vim detected, passing keys to vim")
        for keymap in key_mapping.split(">"):
            log_to_file(f"Processing keymap: {keymap}")
            encoded = encode_key_mapping(window, keymap)
            window.write_to_child(encoded)
    else:
        log_to_file(f"Vim not detected, switching to neighboring window: {direction}")
        boss.active_tab.neighboring_window(direction)
