" ============================================================================
" File:        window.vim
" Description: File contains functions for working with window
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" License:     
" Notes:       
"
" ============================================================================

let s:trans_win_name = "__Translate__"

function! common#window#OpenTrans(text)
    call common#window#GotoTransWindow()

    setlocal buftype=nofile
    setlocal complete=.
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nonumber
    setlocal norelativenumber
    setlocal ft=trans
    setlocal modifiable

    let cmd = "trans ".g:trans_options." \"".a:text."\""
    let translate = system(cmd)
    %delete
    silent! put = translate
    normal gg
    setlocal nomodifiable
endfunction

function! common#window#OpenTransWindow()
    let bufnum = bufnr(s:trans_win_name)
    let bufwinnum = bufwinnr(s:trans_win_name)

    if bufnum != -1 && bufwinnum != -1
        return
    endif
    let wcmd = s:trans_win_name

    if g:trans_win_position == "bottom"
        exe 'silent! botright ' . g:trans_win_height . 'split ' . wcmd
    elseif g:trans_win_position == "right"
        exe 'silent! botright ' . g:trans_win_width . 'vsplit ' . wcmd
    elseif g:trans_win_position == "top"
        exe 'silent! topleft ' . g:trans_win_height . 'split ' . wcmd
    else
        exe 'silent! topleft ' . g:trans_win_width . 'vsplit ' . wcmd
    endif
endfunction

function! common#window#GotoTransWindow()
    if bufname("%") == s:trans_win_name
        return
    endif

    let trans_winnr = bufwinnr(s:trans_win_name)
    if trans_winnr == -1
        call common#window#OpenTransWindow()
        let trans_winnr = bufwinnr(s:trans_win_name)
    endif
    exec trans_winnr . "wincmd w"
endfunction

