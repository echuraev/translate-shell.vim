" ============================================================================
" File:        trans.vim
" Description: Translate text by using translate-shell
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

if exists('loaded_trans')
    finish
endif
let loaded_trans = 1

" Default configuration {{{ "
if !exists('g:trans_bin')
    let g:trans_bin = ""
endif
if !exists('g:trans_default_direction')
    let g:trans_default_direction = ""
endif
if !exists('g:trans_directions_list')
    let g:trans_directions_list = []
endif
if !exists('g:trans_advanced_options')
    let g:trans_advanced_options = ""
endif
if !exists('g:trans_win_width')
    let g:trans_win_width = 50
endif
if !exists('g:trans_win_height')
    let g:trans_win_height = 15
endif
if !exists('g:trans_win_position')
    let g:trans_win_position = 'bottom'
endif
" }}} Default configuration "
" Commands {{{ "
command! -nargs=* TransTerm call trans#TransTerm(<f-args>)
command! -nargs=* Trans call trans#Trans(<f-args>)
command! -nargs=0 TransSelectDirection call trans#TransSelectDirection()
command! -nargs=* TransInteractive call trans#TransInteractive(<f-args>)
command! -nargs=* -range TransVisual call trans#TransVisual(<f-args>)
command! -nargs=0 -range TransVisualSelectDirection call trans#TransVisualSelectDirection()
" }}} Commands "

