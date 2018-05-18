" ============================================================================
" File:        trans.vim
" Description: Autoload functions for translate-shell.vim
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

function! trans#TransTerm(...)
    if s:check() || v:version < 800
        return
    endif
    let cmd = common#trans#generateCMD(g:trans_default_direction)
    if len(a:000) > 0
        let args = ""
        for arg in a:000
            let args = args." ".arg
        endfor
        let cmd = common#trans#generateCMD(args)
    else
        let cmd = common#trans#generateCMD(g:trans_default_direction)
    endif
    execute "term ".cmd
endfunction

function! trans#Trans(...)
    if s:check()
        return
    endif
    let text = expand("<cword>")
    let text = shellescape(text)
    if len(a:000) > 0
        let args = ""
        for arg in a:000
            let args = args." ".arg
        endfor
        let cmd = common#trans#generateCMD(args, text)
    else
        let cmd = common#trans#generateCMD(g:trans_default_direction, text)
    endif
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransVisual(...)
    if s:check()
        return
    endif
    let text = common#common#GetVisualSelection()
    if g:trans_join_lines > 0
        let text = common#common#joinLinesInText(text)
    endif
    let text = shellescape(text)
    if len(a:000) > 0
        let args = ""
        for arg in a:000
            let args = args." ".arg
        endfor
        let cmd = common#trans#generateCMD(args, text)
    else
        let cmd = common#trans#generateCMD(g:trans_default_direction, text)
    endif
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
    let text = expand("<cword>")
    let text = shellescape(text)
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
    let text = common#common#GetVisualSelection()
    if g:trans_join_lines > 0
        let text = common#common#joinLinesInText(text)
    endif
    let text = shellescape(text)
    let cmd = common#trans#generateCMD(trans_direction, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransInteractive(...)
    if s:check()
        return
    endif

    let selected_number = 0
    if len(g:trans_directions_list) > 1 && len(a:000) == 0
        let shown_items = common#trans#getItemsForInputlist()
        let selected_number = inputlist(shown_items) - 1
    endif

    let trans_direction = common#trans#generateTranslateDirection(selected_number)
    if trans_direction == "" || len(a:000) > 0
        let args = g:trans_default_direction
        if len(a:000) > 0
            let args = ""
            for arg in a:000
                let args = args." ".arg
            endfor
        endif
        let text = input("Translate (cmd: ".common#trans#generateCMD(args)."): ")
        let text = shellescape(text)
        let cmd = common#trans#generateCMD(args, text)
    else
        let human_direction = common#trans#getHumanDirectionsList()[selected_number]
        let text = input(human_direction." Translate: ")
        let text = shellescape(text)
        let cmd = common#trans#generateCMD(trans_direction, text)
    endif
    call common#window#OpenTrans(cmd)
endfunction

function! s:check() abort
    let cmd = common#trans#getPathToBin()
    let cmd = cmd.'trans'
    if !executable(cmd)
        echohl WarningMsg | echomsg "Trans unavailable! CMD: ".cmd | echohl None
        return 1
    endif
    return 0
endfunction

