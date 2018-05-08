" ============================================================================
" File:        trans.vim
" Description: Translate text by using translate-shell
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" License:     
" Notes:       
"
" ============================================================================

if exists('loaded_trans')
    finish
endif
let loaded_trans = 1

let g:trans_win_width = 50
let g:trans_win_height = 15
let g:trans_options = "-no-theme -no-ansi :ru" " -dump
let g:trans_win_position = 'bottom'

command! -range TransTerm call trans#TransTerm()
command! -range Trans call trans#Trans()
command! -range TransVisual call trans#TransVisual()

inoremap <silent> <leader>t <ESC>:Trans<CR>
nnoremap <silent> <leader>t :Trans<CR>
vnoremap <silent> <leader>t :TransVisual<CR>
