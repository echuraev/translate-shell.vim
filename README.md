# translate-shell.vim

[![Build Status](https://travis-ci.org/echuraev/translate-shell.vim.svg?branch=master)](https://travis-ci.org/echuraev/translate-shell.vim)

## Intro

***Translate-shell.vim*** is a plugin for translating text without leaving Vim. It
provides a window that displays the translate of word under cursor, selected
text or you can use "on fly" translation and translate inserted text.

To see the plugin in action, please look at [Screencast](#screencast) section.

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Features](#features)
* [Requirements](#requirements)
* [Installation](#installation)
    * [Installation with vim-plug](#installation-with-vim-plug)
* [Getting Started](#getting-started)
* [Screencast](#screencast)
* [TODO List](#todo-list)
* [References](#references)
    * [Author](#author)
    * [Licence](#licence)

<!-- vim-markdown-toc -->

## Features

The following features are supported by translate-shell.vim:

* Translate word under cursor.
* Translate multi line string.
* Select direction of translate from predefined list.
* Interactive translation.
* Open interactive terminal with translate-shell (only **Vim 8**).

## Requirements

The following requirements have to be met in order to be able to use
translate-shell.vim:
* Install translate-shell. Translate-shell is used as a backend for the plugin.
  You can find it on [github](https://github.com/soimort/translate-shell).

## Installation

You can install translate-shell.vim by using any vim plugin manager.

### Installation with vim-plug

If you doesn't have installed translate-shell in path, you can install plugin
by the following command:
```
Plug 'echuraev/translate-shell.vim', { 'do': 'wget -O ~/.vim/trans git.io/trans && chmod +x ~/.vim/trans' }
```
And after it you should specify path to translate-shell by defining
`g:trans_bin` variable e.g:
```
let g:trans_bin = "~/.vim"
```
If you already have installed translate-shell in your PATH then it is enough
to install plugin by the following command:
```
Plug 'echuraev/translate-shell.vim'
```

## Getting Started

Translate-shell.vim provides 6 commands for translation:
* `:Trans [{options}]` - Translate word under cursor.
* `:TransVisual [{options}]` - Translate text in visual selection.
* `:TransSelectDirection` - Translate word under cursor with selecting translate
    direction.
* `:TransVisualSelectDirection` - Translate text in visual selection with
    selecting translate direction.
* `:TransInteractive [{options}]` - Translate inserted text.
* `:TransTerm [{options}]` - Open terminal with interactive translate-shell.
    That works only in Vim 8.

For more convenience, you can create key mapping for these commands e.g:
```
inoremap <silent> <leader>t <ESC>:Trans<CR>
nnoremap <silent> <leader>t :Trans<CR>
vnoremap <silent> <leader>t :TransVisual<CR>
```

## Screencast
![translate-shell.vim screencast](doc/screencast.gif)

## TODO List
- [ ] Keep translate story
    - [ ] Choose the better translate to save
- [ ] Nice syntax highlighting
- [ ] Folding for translation on multiple languages
- [ ] Possibility to join lines for better translation
- [ ] Refactor and join translate functions (visual and not)

## References

### Author

Egor Churaev egor.churaev@gmail.com

### Licence

GPL-3.0

