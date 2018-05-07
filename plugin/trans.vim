" ============================================================================
" File:        trans.vim
" Description: 
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" License:     
" Notes:       
"
" ============================================================================

if exists('loaded_trans')
    finish
endif
let loaded_trans = 1

let g:trans_win_name = "__Translate__"
let g:trans_win_width = 50
let g:trans_win_height = 25
let g:trans_options = ":ru+de"

command! -range TransTerm call trans#TransTerm()
command! -range Trans call trans#Trans()
command! -range TransVisual call trans#TransVisual()
command! -range TransOpen call trans#OpenWindow()


inoremap <silent> <leader>t <ESC>:Trans<CR>
nnoremap <silent> <leader>t :Trans<CR>
vnoremap <silent> <leader>t :TransVisual<CR>
