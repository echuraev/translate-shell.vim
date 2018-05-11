" ============================================================================
" File:        common.vim
" Description: File contains some common functions
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

" Function that returns visual selection
function! common#common#GetVisualSelection() abort
  try
    let a_save = @a
    silent! normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

