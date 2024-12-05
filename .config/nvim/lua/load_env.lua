local function load_env_file(filepath)
  local file = io.open(filepath, "r")
  if not file then
    print("Could not open .env file: " .. filepath)
    return
  end

  for line in file:lines() do
    -- Ignore empty lines and comments
    if line:match("^%s*#") or line:match("^%s*$") then
      goto continue
    end

    -- Parse key-value pairs
    local key, value = line:match("^%s*([%w_]+)%s*=%s*(.*)%s*$")
    if key and value then
      -- Remove quotes if present
      value = value:gsub('^["\']', ''):gsub('["\']$', '')
      vim.fn.setenv(key, value)
    end

    ::continue::
  end

  file:close()
end

-- Load the .env file (adjust the path as necessary)
load_env_file(vim.fn.stdpath('config') .. '/.env')
