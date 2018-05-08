" ============================================================================
" File:        trans.vim
" Description: Autoload functions for translate-shell.vim
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" License:     
" Notes:       
"
" ============================================================================

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
    let selection = common#common#GetVisualSelection()
    if strlen(selection) == 0
        call common#window#OpenTrans(expand("<cword>"))
    else
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

