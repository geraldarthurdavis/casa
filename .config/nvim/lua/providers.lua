-- providers.lua
--
-- configure neovims python providers
--
-- create virtual envs with `pyenv virtualenv 3.9.10 vim-3.9.10` and put paths here. can then install pip packages to those envs

local g = vim.g

g.python3_host_prog = '/Users/g/.pyenv/versions/3.9.10/envs/vim-3.9.10/bin/python'
g.python_host_prog = '/Users/g/.pyenv/versions/2.7.18/envs/vim-2.7.18/bin/python'
