import re
import syslog
import subprocess

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut


# def is_window_vim(window, vim_id):
    # fp = window.child.foreground_processes

    # # syslog.syslog(syslog.LOG_INFO, f'pass_keys.py: window: {window}')
    # syslog.syslog(syslog.LOG_INFO, f'pass_keys.py: vim_id: {vim_id}')
    # syslog.syslog(syslog.LOG_INFO, f'pass_keys.py: fp: {fp}')
    # return any(re.search(vim_id, p['cmdline'][0] if len(p['cmdline']) else '', re.I) for p in fp)

def is_window_vim(window, vim_id='nvim'):
    def check_process_and_children(pid, depth=0):
        if depth > 5:  # Limit recursion depth to avoid infinite loops
            return False

        try:
            # Get process info
            process = subprocess.run(['ps', '-o', 'pid,ppid,command', '-p', str(pid)],
                                     capture_output=True, text=True, check=True)
            
            # Check if current process is Vim/Neovim
            for line in process.stdout.splitlines()[1:]:  # Skip header
                _, _, cmd = line.split(None, 2)
                if re.search(vim_id, cmd, re.I):
                    return True

            # Check child processes
            children = subprocess.run(['pgrep', '-P', str(pid)],
                                      capture_output=True, text=True, check=True)
            
            for child_pid in children.stdout.splitlines():
                if check_process_and_children(child_pid, depth + 1):
                    return True

        except subprocess.CalledProcessError as e:
            syslog.syslog(syslog.LOG_ERR, f'pass_keys.py: Error checking process {pid}: {e}')

        return False

    # Get the list of foreground processes for the window
    fp = window.child.foreground_processes
    for process in fp:
        pid = process.get('pid')
        if check_process_and_children(pid):
            return True

    return False


def encode_key_mapping(window, key_mapping):
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

    return window.encoded_key(event)


def main():
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    direction = args[1]
    key_mapping = args[2]
    vim_id = args[3] if len(args) > 3 else "n?vim"

    window = boss.window_id_map.get(target_window_id)
# Open a connection to the syslog
    syslog.openlog(ident="MyPythonScript", logoption=syslog.LOG_PID, facility=syslog.LOG_USER)

# Log a message
    syslog.syslog(syslog.LOG_INFO, f'pass_keys.py: is_window_vim: {is_window_vim(window, vim_id)}')

    if window is None:
        syslog.syslog(syslog.LOG_INFO, f'pass_keys.py: Window is none. {window}')
        return
    if is_window_vim(window, vim_id):
        for keymap in key_mapping.split(">"):
            encoded = encode_key_mapping(window, keymap)
            window.write_to_child(encoded)
    else:
        boss.active_tab.neighboring_window(direction)

    # Close the syslog connection
    syslog.closelog()

