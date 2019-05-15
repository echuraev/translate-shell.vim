" ============================================================================
" File:        trans.vim
" Description: FZF functions for translate-shell.vim
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

if exists("loaded_fzf_trans")
  finish
endif
let loaded_fzf_trans = 1

" Helper functions {{{ "
function! s:fzfRunWrapper(list, text)
    let options = "+m --prompt \"".a:text."\""
    let selected = fzf#run({
              \ 'source':  a:list,
              \ 'options': options,
              \ 'down':    g:trans_win_height})
    if len(selected) == 0
        return ""
    endif
    return selected[0]
endfunction

function! fzf#trans#TransGetDirection()
    let directions_list = ['Autodetect']
    let directions_list = directions_list + common#trans#GetLanguagesList()

    let from = s:fzfRunWrapper(directions_list, "Select from direction> ")
    let to = s:fzfRunWrapper(directions_list, "Select to direction> ")

    let from_code = get(common#trans#GetLanguagesDict(), from, '')
    let to_code = get(common#trans#GetLanguagesDict(), to, '')
    return from_code.":".to_code
endfunction

function! fzf#trans#TransSelectItemFromList(directions_list, text)
    let index = 0
    let selected = s:fzfRunWrapper(a:directions_list, a:text)
    if selected == ""
        return -1
    endif
    for i in range(0, len(a:directions_list)-1)
        if selected == a:directions_list[i]
            let index = i
            break
        endif
    endfor
    return index
endfunction
" }}} Helper functions "

function! fzf#trans#TransSelectDirection(line1, line2, count)
    if !exists(':FZF')
        echohl WarningMsg | echomsg "FZF not found!" | echohl None
        return
    endif
    call trans#TransSelectDirection(1, a:line1, a:line2, a:count)
endfunction

function! fzf#trans#TransInteractive()
    if !exists(':FZF')
        echohl WarningMsg | echomsg "FZF not found!" | echohl None
        return
    endif
    call trans#TransInteractive(1)
endfunction

function! fzf#trans#TransChangeDefaultDirection()
    if !exists(':FZF')
        return
    endif
    if trans#Check()
        return
    endif
    let direction = fzf#trans#TransGetDirection()
    if direction == ""
        return
    endif
    let g:trans_default_direction = direction
endfunction

