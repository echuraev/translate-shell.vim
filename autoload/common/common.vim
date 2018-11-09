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

function! common#common#JoinLinesInText(text)
    let text = substitute(a:text, '\t', ' ', 'g')
    let lines = split(text, '\n')
    let final_lines = []
    for line in lines
        let line = substitute(line, '\v^[ ]*', '', 'g') " Remove spaces in the beginning of the line
        let line = substitute(line, '\v[ ]{2,}', ' ', 'g') " Remove more than one space in one place
        call add(final_lines, line)
    endfor
    let text = join(final_lines, ' ')
    let text = substitute(text, '  ', '\n', 'g')
    return text
endfunction

function! common#common#GenerateInputlist(text, list)
    let shown_items = [a:text]
    for i in range(1, len(a:list))
        call add(shown_items, i.'. '.a:list[i-1])
    endfor
    return shown_items
endfunction

