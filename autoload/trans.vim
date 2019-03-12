" ============================================================================
" File:        trans.vim
" Description: Autoload functions for translate-shell.vim
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

" Public functions {{{ "
function! trans#TransTerm(...)
    if s:check() || v:version < 800
        return
    endif
    let args = common#trans#GenerateArgs(a:000)
    let cmd = common#trans#GenerateCMD(args)
    execute "term ".cmd
endfunction

function! trans#Trans(line1, line2, count, ...)
    if s:check()
        return
    endif
    let text = s:prepareText(a:count)
    let args = common#trans#GenerateArgs(a:000)
    let cmd = common#trans#GenerateCMD(args, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransSelectDirection(line1, line2, count)
    if s:check()
        return
    endif

    let size_trans_directions_list = len(g:trans_directions_list)
    if size_trans_directions_list == 0
        call trans#Trans(a:line1, a:line2, a:count)
        return
    endif

    let selected_number = 0
    if size_trans_directions_list > 1
        let shown_items = common#trans#GetItemsForInputlist()
        let selected_number = inputlist(shown_items) - 1
    endif

    let trans_direction = common#trans#GenerateTranslateDirection(selected_number)
    if trans_direction == ""
        return
    endif
    let text = s:prepareText(a:count)
    let cmd = common#trans#GenerateCMD(trans_direction, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransInteractive(...)
    if s:check()
        return
    endif

    let selected_number = 0
    if len(g:trans_directions_list) > 1 && len(a:000) == 0
        let shown_items = common#trans#GetItemsForInputlist()
        let selected_number = inputlist(shown_items) - 1
    endif

    let args = common#trans#GenerateTranslateDirection(selected_number)
    if args == "" || len(a:000) > 0
        let args = common#trans#GenerateArgs(a:000)
        let text = input("Translate (cmd: ".common#trans#GenerateCMD(args)."): ")
    else
        let human_direction = common#trans#GetHumanDirectionsList()[selected_number]
        let text = input(human_direction." Translate: ")
    endif
    let text = common#trans#PrepareTextToTranslating(text)
    let cmd = common#trans#GenerateCMD(args, text)
    call common#window#OpenTrans(cmd)
endfunction

function! trans#TransOpenHistoryWindow()
    if s:check()
        return
    endif
    call common#window#OpenTransHistoryWindow()
endfunction

function! trans#TransChangeDefaultDirection()
    if s:check()
        return
    endif
    let directions_list = ['Autodetect']
    let directions_list = directions_list + common#trans#GetLanguagesList()

    let shown_items = common#common#GenerateInputlist("Select from direction:", directions_list)
    let selected = inputlist(shown_items) - 1
    let from = directions_list[selected]

    let shown_items = common#common#GenerateInputlist("Select to direction:", directions_list)
    let selected = inputlist(shown_items) - 1
    let to = directions_list[selected]

    let from_code = ""
    if from != 'Autodetect'
        let from_code = common#trans#GetLanguagesDict()[from]
    endif
    let to_code = ""
    if to != 'Autodetect'
        let to_code = common#trans#GetLanguagesDict()[to]
    endif
    let g:trans_default_direction = from_code.":".to_code
endfunction
" }}} Public functions "
" Private functions {{{ "
function! s:check() abort
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

