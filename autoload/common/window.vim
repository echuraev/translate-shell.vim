" ============================================================================
" File:        window.vim
" Description: 
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" License:     
" Notes:       
"
" ============================================================================

" Basic init {{{ "
redir => s:ftype_out
silent filetype
redir END
if s:ftype_out !~# 'detection:ON'
    echomsg 'Tagbar: Filetype detection is turned off, skipping plugin'
    unlet s:ftype_out
    finish
endif
unlet s:ftype_out

let g:tagbar#icon_closed = g:tagbar_iconchars[0]
let g:tagbar#icon_open   = g:tagbar_iconchars[1]

let s:type_init_done    = 0
let s:autocommands_done = 0
let s:statusline_in_use = 0
let s:init_done = 0

" 0: not checked yet; 1: checked and found; 2: checked and not found
let s:checked_ctags       = 0
let s:checked_ctags_types = 0
let s:ctags_is_uctags     = 0

let s:new_window      = 1
let s:is_maximized    = 0
let s:winrestcmd      = ''
let s:short_help      = 1
let s:nearby_disabled = 0
let s:paused = 0
let s:pwin_by_tagbar = 0
let s:buffer_seqno = 0
let s:vim_quitting = 0
let s:last_alt_bufnr = -1

let s:window_expanded   = 0
let s:expand_bufnr = -1
let s:window_pos = {
    \ 'pre'  : { 'x' : 0, 'y' : 0 },
    \ 'post' : { 'x' : 0, 'y' : 0 }
\}

let s:delayed_update_files = []

let g:loaded_tagbar = 1

let s:last_highlight_tline = 0

let s:warnings = {
    \ 'type': [],
    \ 'encoding': 0
\ }
" }}} Basic init "

function! window#OpenWindow() abort "flags) abort
    let autofocus = 'f' " a:flags =~# 'f'
    let jump      = 'j' " a:flags =~# 'j'
    let autoclose = 'c' " a:flags =~# 'c'

    let curfile = fnamemodify(bufname('%'), ':p')
    let curline = line('.')

    " If the trans window is already open check jump flag
    " Also set the autoclose flag if requested
    let transwinnr = bufwinnr(s:TransBufName())
    echo transwinnr
    if transwinnr != -1
        "if winnr() != transwinnr && jump
        "    call s:goto_win(transwinnr)
        "    call s:HighlightTag(g:trans_autoshowtag != 2, 1, curline)
        "endif
        return
    endif
"
"    " Use the window ID if the functionality exists, this is more reliable
"    " since the window number can change due to the Tagbar window opening
"    if exists('*win_getid')
"        let prevwinid = win_getid()
"        if winnr('$') > 1
"            call s:goto_win('p', 1)
"            let pprevwinid = win_getid()
"            call s:goto_win('p', 1)
"        endif
"    else
"        let prevwinnr = winnr()
"        if winnr('$') > 1
"            call s:goto_win('p', 1)
"            let pprevwinnr = winnr()
"            call s:goto_win('p', 1)
"        endif
"    endif
"
"    " This is only needed for the CorrectFocusOnStartup() function
"    let s:last_autofocus = autofocus
"
"    if !s:Init(0)
"        return 0
"    endif
"
"    " Expand the Vim window to accommodate for the Tagbar window if requested
"    " and save the window positions to be able to restore them later.
"    if g:tagbar_expand >= 1 && !s:window_expanded &&
"     \ (has('gui_running') || g:tagbar_expand == 2)
"        let s:window_pos.pre.x = getwinposx()
"        let s:window_pos.pre.y = getwinposy()
"        let &columns += g:tagbar_width + 1
"        let s:window_pos.post.x = getwinposx()
"        let s:window_pos.post.y = getwinposy()
"        let s:window_expanded = 1
"    endif
"
"    let s:window_opening = 1
"    if g:tagbar_vertical == 0
"        let mode = 'vertical '
"        let openpos = g:tagbar_left ? 'topleft ' : 'botright '
"        let width = g:tagbar_width
"    else
"        let mode = ''
"        let openpos = g:tagbar_left ? 'leftabove ' : 'rightbelow '
"        let width = g:tagbar_vertical
"    endif
"    exe 'silent keepalt ' . openpos . mode . width . 'split ' . s:TagbarBufName()
"    exe 'silent ' . mode . 'resize ' . width
"    unlet s:window_opening
"
"    call s:InitWindow(autoclose)
"
"    " If the current file exists, but is empty, it means that it had a
"    " processing error before opening the window, most likely due to a call to
"    " currenttag() in the statusline. Remove the entry so an error message
"    " will be shown if the processing still fails.
"    if empty(s:known_files.get(curfile))
"        call s:known_files.rm(curfile)
"    endif
"
"    call s:AutoUpdate(curfile, 0)
"    call s:HighlightTag(g:tagbar_autoshowtag != 2, 1, curline)
"
"    if !(g:tagbar_autoclose || autofocus || g:tagbar_autofocus)
"        if exists('*win_getid')
"            if exists('pprevwinid')
"                noautocmd call win_gotoid(pprevwinid)
"            endif
"            call win_gotoid(prevwinid)
"        else
"            " If the Tagbar winnr is identical to one of the saved values
"            " then that means that the window numbers have changed.
"            " Just jump back to the previous window since we won't be able to
"            " restore the window history.
"            if winnr() == prevwinnr
"             \ || (exists('pprevwinnr') && winnr() == pprevwinnr)
"                call s:goto_win('p')
"            else
"                if exists('pprevwinnr')
"                    call s:goto_win(pprevwinnr, 1)
"                endif
"                call s:goto_win(prevwinnr)
"            endif
"        endif
"    endif

    echo('OpenWindow finished')
endfunction

function! s:TransBufName() abort
    if !exists('t:trans_buf_name')
        let s:buffer_seqno += 1
        let t:trans_buf_name = 'Trans.' . s:buffer_seqno
    endif

    return t:trans_buf_name
endfunction


"function! s:goto_win(winnr, ...) abort
"    let cmd = type(a:winnr) == type(0) ? a:winnr . 'wincmd w'
"                                     \ : 'wincmd ' . a:winnr
"    let noauto = a:0 > 0 ? a:1 : 0
"
"    call tagbar#debug#log("goto_win(): " . cmd . ", " . noauto)
"
"    if noauto
"        noautocmd execute cmd
"    else
"        execute cmd
"    endif
"endfunction

