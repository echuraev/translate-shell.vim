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
let g:trans_options = ":ru"
let g:trans_win_position = 'bottom'
let g:trans_directions_list = [
    \['en', 'ru'],
    \['ru', 'en'],
    \['en', 'de'],
    \['de', 'ru'],
    \['en', 'ru', 'de'],
\]

command! -range TransTerm call trans#TransTerm()
command! -range Trans call trans#Trans()
command! -range TransVisual call trans#TransVisual()
command! -range TransDirectionInteractive call trans#Trans() " [German > English] Translate: <input>
command! -range TransSelectDirection call trans#TransSelectDirection()
command! -range TransVisualSelectDirection call trans#TransVisualSelectDirection()

inoremap <silent> <leader>t <ESC>:Trans<CR>
nnoremap <silent> <leader>t :Trans<CR>
vnoremap <silent> <leader>t :TransVisual<CR>
