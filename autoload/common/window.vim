" ============================================================================
" File:        window.vim
" Description: File contains functions for working with window
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

let s:trans_win_name = "__Translate__"

function! common#window#OpenTrans(cmd)
    call common#window#GotoTransWindow()

    call s:maps()
    setlocal buftype=nofile
    setlocal complete=.
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nonumber
    setlocal norelativenumber
    setlocal ft=trans
    setlocal modifiable

    let translate = system(a:cmd)
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

function! s:maps()
    nnoremap <silent> <buffer> <CR> :call common#window#SaveSelectedTranslation()<CR>
endfunction

function! common#window#SaveSelectedTranslation()
    if g:trans_save_history == 0
        redraw | echohl WarningMsg | echo "Cannot save translation. g:trans_save_history is zero" | echohl None
        return
    endif
    let source_text = common#trans#getCurrentSourceText()
    " Get and trim selected line
    let translation = substitute(getline('.'), '^\s*\(.\{-}\)\s*$', '\1', '')
    let history_file =  common#trans#addTranslationToHistory(source_text, translation)
    if history_file =~ "^Error!"
        redraw | echo history_file
        return
    endif
    if g:trans_close_window_after_saving > 0
        q
    endif
    redraw | echo "Saved: ".source_text." -> ".translation.". To file: ".history_file
endfunction

