# 🏡 casa

my developer home

see the Notion document

## principals

kintsugi

## furnish

an optimal developer environment is performant, secure, stable, and ultimately empowers me to creatively and quickly solve problems

### apps

my staples are:

* Chrome (internet)
* Notion (notes, journal)
* kitty (terminal)
- change the logo to something fun like Engi's logo :) 
* Figma (design)
* Linear (planning, management)
* Slack (communications)
* 1Password
* Ulyssess (writing)
* Notion (operations, dynamic docs)
* Sip (color grab) https://sipapp.io/
- sip license is per device so need to buy one for new machine
* Pocket
* Paw
* Xcode

#### hosted

* google drive (formal docs, sheets, etc.)

### developer


* install homebrew

* kitty
- download SF Mono fonts

* zsh
- zgen for plugins

* tmux
- sync colors of tmux tabline and vim tabbar line https://vimawesome.com/plugin/tmuxline-vim
- then manually sync kitty and there will be a consistent theme

* fzf
- install fzf and command line completion
- terminal usability things
- use ripgrep as the search program and configure it

* fd
- replce find
- maybe no need?

* rg
- search for code
- also gives a trimmed list of files to search from

* vim
- neovim https://neovim.io/
- nvchad

* docker
- install with brew
- `brew install --cask docker`


* languages, frameworks, tooling (git)

* javascript
- NVM, node
- nvm alias engi, nvm install node --alias engi

* python
- will need to have cmake and xcode installed to install py
- mac ships with 2.7, install manager like PyEnv and upgrade to 3.x
- install PipEnv for dependency management 


* misc.
- mac edit /etc/pam.d/sudo to allow using Touch ID for sudo (make sure enabled in systems settings as well)

#### scripts & searching

custom scripts defined

(f) *find* files fuzzy (and open in vim)
(s) *search* code fuzzy (and open in vim at line of match)
(g) *go* to directory or file fuzzy (and cd there)


## clean

part of maintaining an optimal developer environment is monitoring the machine

* vim performance
* free memory
* time to cold start chrome


### tmux

tmux is primarily provide robust terminal "window" management and ensure that work isn't lost when the terminal exits sometimes accidentally

*ctrl-t* is the leader to beginning operating in tmux "command mode". this will exit after a short amount of time so is to-be used in quick succession with
the command

