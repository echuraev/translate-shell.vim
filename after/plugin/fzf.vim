" ============================================================================
" File:        fzf.vim
" Description: FZF commands for translate-shell.vim
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

if !exists(':FZF')
    finish
endif

command! -nargs=0 -range FZFTransSelectDirection call fzf#trans#TransSelectDirection(<line1>, <line2>, <count>)
command! -nargs=0 FZFTransInteractive call fzf#trans#TransInteractive()
command! -nargs=0 FZFTransChangeDefaultDirection call fzf#trans#TransChangeDefaultDirection()

