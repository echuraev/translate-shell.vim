" ============================================================================
" File:        trans.vim
" Description: Autoload functions for translate-shell.vim
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

" Public functions {{{ "
function! trans#TransTerm(...)
    if trans#Check() || v:version < 800
        return
    endif
    let args = common#trans#GenerateArgs(a:000)
    let cmd = common#trans#GenerateCMD(args)
    execute "term ".cmd
endfunction

function! trans#Trans(line1, line2, count, ...)
    if trans#Check()
        return
    endif
    let text = s:prepareText(a:count)
    let args = common#trans#GenerateArgs(a:000)
    let cmd = common#trans#GenerateCMD(args, text)
    call common#window#OpenTrans(cmd)
endfunction

" select list is a variable for choise the way for selecting translate
" direction:
" 0 - vim way by using inputlist
" 1 - by using fzf
function! trans#TransSelectDirection(select_list, line1, line2, count)
    if trans#Check()
        return
    endif

    let trans_direction = common#trans#TransGetPredefinedDirection(a:select_list)
    if trans_direction == ""
        return
    endif
    let text = s:prepareText(a:count)
    let cmd = common#trans#GenerateCMD(trans_direction, text)
    call common#window#OpenTrans(cmd)
endfunction

" select list is a variable for choise the way for selecting translate
" direction:
" 0 - vim way by using inputlist
" 1 - by using fzf
function! trans#TransInteractive(select_list, ...)
    if trans#Check()
        return
    endif

    let trans_direction = ""
    if g:trans_interactive_full_list == 0
        let trans_direction = common#trans#TransGetPredefinedDirection(a:select_list)
    else
        if a:select_list == 0
            let trans_direction = common#trans#TransGetDirection()
        else
            let trans_direction = fzf#trans#TransGetDirection()
        endif
    endif
    if trans_direction == ""
        return
    endif
    if len(a:000) > 0
        let args = common#trans#GenerateArgs(a:000)
        let text = input("Translate (cmd: ".common#trans#GenerateCMD(args)."): ")
    else
        let direction_list = common#trans#TextDirectionToList(trans_direction)
        let human_direction = common#trans#DirectionToHuman(direction_list)
        let text = input(human_direction." Translate: ")
    endif
    let text = common#trans#PrepareTextToTranslating(text)
    let cmd = common#trans#GenerateCMD(trans_direction, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransOpenHistoryWindow()
    if trans#Check()
        return
    endif
    call common#window#OpenTransHistoryWindow()
endfunction

function! trans#TransChangeDefaultDirection()
    if trans#Check()
        return
    endif
    let g:trans_default_direction = common#trans#TransGetDirection()
endfunction

function! trans#Check() abort
    let cmd = common#trans#GetPathToBin()
    let cmd = cmd.'trans'
    if !executable(cmd)
        if has('win32')
            silent! let l:status = system(cmd.' -h')
            if strlen(l:status) > 0
                return 0
            endif
        endif
        echohl WarningMsg | echomsg "Trans unavailable! CMD: ".cmd | echohl None
        return 1
    endif
    return 0
endfunction
" }}} Public functions "
" Private functions {{{ "
function! s:prepareText(count)
    if (a:count == -1)
        let text = expand("<cword>")
    else
        let text = common#common#GetVisualSelection()
        if g:trans_join_lines > 0
            let text = common#common#JoinLinesInText(text)
        endif
    endif
    return common#trans#PrepareTextToTranslating(text)
endfunction
" }}} Private functions "

