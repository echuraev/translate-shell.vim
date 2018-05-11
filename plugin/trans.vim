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
if !exists('g:trans_directions_list')
    let g:trans_directions_list = []
endif
" }}} Default configuration "

let g:trans_default_direction = ":ru"
let g:trans_directions_list = [
    \['en', 'ru'],
    \['ru', 'en'],
    \['en', 'de'],
    \['de', 'ru'],
    \['en', 'ru', 'de'],
    \['', 'ru'],
    \['', ''],
\]
" TODO: Add tests cases on the last two items

" Commands {{{ "
command! TransTerm call trans#TransTerm()
command! Trans call trans#Trans()
command! TransSelectDirection call trans#TransSelectDirection()
command! TransInteractive call trans#TransInteractive()
command! -range TransVisual call trans#TransVisual()
command! -range TransVisualSelectDirection call trans#TransVisualSelectDirection()
" }}} Commands "

inoremap <silent> <leader>t <ESC>:Trans<CR>
nnoremap <silent> <leader>t :Trans<CR>
vnoremap <silent> <leader>t :TransVisual<CR>
