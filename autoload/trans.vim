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
    let cmd = common#trans#generateCMD(g:trans_options)
    execute "term ".cmd
endfunction

function! trans#Trans()
    if s:check()
        return
    endif
    let text = "\"".expand("<cword>")."\""
    let cmd = common#trans#generateCMD(g:trans_options, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransVisual()
    if s:check()
        return
    endif
    let text = "\"".common#common#GetVisualSelection()."\""
    let cmd = common#trans#generateCMD(g:trans_options, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransSelectDirection()
    if s:check()
        return
    endif

    let size_trans_directions_list = len(g:trans_directions_list)
    if size_trans_directions_list == 0
        call trans#Trans()
        return
    endif

    let selected_number = 0
    if size_trans_directions_list > 1
        let shown_items = common#trans#getItemsForInputlist()
        let selected_number = inputlist(shown_items) - 1
    endif

    let trans_direction = common#trans#generateTranslateDirection(selected_number)
    if trans_direction == ""
        return
    endif
    let text = "\"". expand("<cword>")."\""
    let cmd = common#trans#generateCMD(trans_direction, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransVisualSelectDirection()
    if s:check()
        return
    endif

    let size_trans_directions_list = len(g:trans_directions_list)
    if size_trans_directions_list == 0
        call trans#TransVisual()
        return
    endif

    let selected_number = 0
    if size_trans_directions_list > 1
        let shown_items = common#trans#getItemsForInputlist()
        let selected_number = inputlist(shown_items) - 1
    endif

    let trans_direction = common#trans#generateTranslateDirection(selected_number)
    if trans_direction == ""
        return
    endif
    let text = "\"".common#common#GetVisualSelection()."\""
    let cmd = common#trans#generateCMD(trans_direction, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransInteractive()
    if s:check()
        return
    endif

    let selected_number = 0
    if len(g:trans_directions_list) > 1
        let shown_items = common#trans#getItemsForInputlist()
        let selected_number = inputlist(shown_items) - 1
    endif

    let trans_direction = common#trans#generateTranslateDirection(selected_number)
    if trans_direction == ""
        let text = input("Translate (cmd: ".common#trans#generateCMD(g:trans_options)."): ")
        let cmd = common#trans#generateCMD(g:trans_options, text)
    else
        let human_direction = common#trans#getHumanDirectionsList()[selected_number]
        let text = input(human_direction." Translate: ")
        let cmd = common#trans#generateCMD(trans_direction, text)
    endif
    call common#window#OpenTrans(cmd)
endfunction

function! s:check() abort
    if !executable('trans')
        echohl WarningMsg | echomsg "Trans unavailable!" | echohl None
        return 1
    endif
    return 0
endfunction

