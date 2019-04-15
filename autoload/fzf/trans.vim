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
function! fzf#trans#TransGetDirection()
    let directions_list = ['Autodetect']
    let directions_list = directions_list + common#trans#GetLanguagesList()

    " Getting from direction {{{ "
    let selected = fzf#run({
              \ 'source': directions_list,
              \ 'options': '+m --prompt Select\ from\ direction\>\ ',
              \ 'down':    '30%'})
    if len(selected) == 0
        return ""
    endif
    let from = selected[0]
    " }}} Getting from direction "
    " Getting to direction {{{ "
    let selected = fzf#run({
              \ 'source': directions_list,
              \ 'options': '+m --prompt Select\ to\ direction\>\ ',
              \ 'down':    '30%'})
    if len(selected) == 0
        return ""
    endif
    let to = selected[0]
    " }}} Getting to direction "

    let from_code = get(common#trans#GetLanguagesDict(), from, '')
    let to_code = get(common#trans#GetLanguagesDict(), to, '')
    return from_code.":".to_code
endfunction

function! fzf#trans#TransGetPredefinedDirection()
    let directions_list = common#trans#GetHumanDirectionsList()
    let size_directions_list = len(directions_list)
    if size_directions_list == 0
        return g:trans_default_direction
    endif

    let index = 0
    if size_directions_list > 1
        let selected = fzf#run({
                  \ 'source': directions_list,
                  \ 'options': '+m --prompt Select\ languages\>\ ',
                  \ 'down':    '30%'})
        if len(selected) == 0
            return ""
        endif
        for i in range(0, len(directions_list)-1)
            if selected[0] == directions_list[i]
                let index = i
                break
            endif
        endfor
    endif
    return common#trans#GenerateTranslateDirection(index)
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
