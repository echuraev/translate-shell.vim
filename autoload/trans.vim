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
    call trans#OpenTransWindow()

    setlocal buftype=nofile
    setlocal complete=.
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nonumber
    setlocal norelativenumber
    setlocal ft=trans
    setlocal modifiable

    let cmd = "trans ".g:trans_options." \"".a:text."\""
    echo cmd
    let translate = system(cmd)
    %delete
    put = translate
    normal gg
    "call setline(line('.'), getline('.') . ' ' . translate)
    setlocal nomodifiable
endfunction

function! trans#OpenTransWindow()
    let bufnum = bufnr(g:trans_win_name)

    if bufnum == -1
        " Create a new buffer
        let wcmd = g:trans_win_name
    else
        " Edit the existing buffer
        let wcmd = '+buffer' . bufnum
    endif

    if g:trans_win_position == "bottom"
        echo g:trans_win_position
        exe 'silent! botright ' . g:trans_win_height . 'split ' . wcmd
    elseif g:trans_win_position == "right"
        exe 'silent! botright ' . g:trans_win_width . 'vsplit ' . wcmd
    elseif g:trans_win_position == "top"
        echo g:trans_win_position
        exe 'silent! topleft ' . g:trans_win_height . 'split ' . wcmd
    else
        exe 'silent! topleft ' . g:trans_win_width . 'vsplit ' . wcmd
    endif
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

