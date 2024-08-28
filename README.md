# 🏡 benchi

[Project Bootstrap Notion](https://www.notion.so/Project-Bootstrap-6b9156f85daa49bda8d53a46b34500e1)

## Vim Configuration

`nvim/lua/` holds all vim configuration files most notably `plugins.lua` and `init.lua`.

`nvim/lua/plugin/packer_compiled.lua` is a generated file.

## Misc.

### vim-kitty-navigator

https://sw.kovidgoyal.net/kitty/faq/#how-do-i-specify-command-line-options-for-kitty-on-macos

This setup is key for using hjkl navigation for all panes in a window seamlessly within vim and kitty terminal.

1. Make sure the pass_keys and get_layout code is right and being called
2. Use cmdline options so kitty listens for messages from vim
    * i've had this break before. navigation works partially but doesn't work in vim splits/panes. when this happens it's likely because kitty wasn't started with the options
