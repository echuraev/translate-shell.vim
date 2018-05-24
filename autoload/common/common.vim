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

function! common#common#joinLinesInText(text)
    let text = substitute(a:text, "  ", " ", "g")
    let text = substitute(text, "\n", " ", "g")
    let text = substitute(text, "  ", "\\n", "g")
    return text
endfunction

function! common#common#GenerateInputlist(text, list)
    let shown_items = [a:text]
    for i in range(1, len(a:list))
        call add(shown_items, i.'. '.a:list[i-1])
    endfor
    return shown_items
endfunction

