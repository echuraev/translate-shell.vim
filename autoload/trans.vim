" ============================================================================
" File:        trans.vim
" Description: Autoload functions for translate-shell.vim
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" License:     
" Notes:       
"
" ============================================================================

let s:prev_selection = ""

function! trans#TransTerm()
    if s:check() || v:version < 800
        return
    endif
    execute "term trans ".g:trans_options.""
endfunction

function! trans#Trans()
    if s:check()
        return
    endif
    let cur_line = line('.')
    let cur_col = col('.')
    let selection = common#common#GetVisualSelection()
    call cursor(cur_line, cur_col)
    if s:prev_selection == selection
        let selection = ""
    endif
    if strlen(selection) == 0
        call common#window#OpenTrans(expand("<cword>"))
    else
        let s:prev_selection = selection
        call common#window#OpenTrans(selection)
    endif
endfunction

function! s:check() abort
    if !executable('trans')
        echohl WarningMsg | echomsg "Trans unavailable!" | echohl None
        return 1
    endif
    return 0
endfunction

