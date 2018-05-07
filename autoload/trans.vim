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

    let cmd = "trans ".g:trans_options." \"".a:text."\""
    echo cmd
    let translate = system(cmd)
    put = translate
    "call setline(line('.'), getline('.') . ' ' . translate)
    "setlocal nomodifiable
endfunction

function! trans#OpenTransWindow(...)
    let para = a:0>0 ? a:1 : 'h'
    let bufnum = bufnr(g:trans_win_name)

    if bufnum == -1
        " Create a new buffer
        let wcmd = g:trans_win_name
    else
        " Edit the existing buffer
        let wcmd = '+buffer' . bufnum
    endif

    if para == 'h'
        exe 'silent! bot ' . g:trans_win_height . 'split ' . wcmd
    else
        exe 'silent! botright ' . g:trans_win_width . 'vsplit ' . wcmd
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

