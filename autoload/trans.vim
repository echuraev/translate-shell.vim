" ============================================================================
" File:        trans.vim
" Description: 
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" License:     
" Notes:       
"
" ============================================================================

" https://github.com/cpiger/NeoDebug/commit/89234b603b9f6da8cb070764e291d050b8cdaff2
function! trans#OpenTrans(text)
    call trans#GotoTransWindow()

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

function! trans#OpenTransWindow()
    let bufnum = bufnr(g:trans_win_name)

    if bufnum != -1
        return
    endif
    let wcmd = g:trans_win_name

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

function! trans#GotoTransWindow()
    if bufname("%") == g:trans_win_name
        return
    endif

    let trans_winnr = bufwinnr(g:trans_win_name)
    if trans_winnr == -1
        call trans#OpenTransWindow()
        let trans_winnr = bufwinnr(g:trans_win_name)
    endif
    exec trans_winnr . "wincmd w"
endfunction

function! trans#TransTerm()
    if s:check()
        return
    endif
    execute "term trans ".g:trans_options.""
endfunction

function! trans#Trans()
    if s:check()
        return
    endif
    call trans#OpenTrans(expand("<cword>"))
endfunction

function! trans#TransVisual()
    if s:check()
        return
    endif
    call trans#OpenTrans(common#common#GetVisualSelection())
endfunction

function! s:check() abort
    if !executable('trans')
        echohl WarningMsg | echomsg "Trans unavailable!" | echohl None
        return 1
    endif
    return 0
endfunction

