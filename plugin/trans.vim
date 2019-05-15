" ============================================================================
" File:        trans.vim
" Description: Translate text by using translate-shell
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

if exists('loaded_trans')
    finish
endif
let loaded_trans = 1

" Default configuration {{{ "
if !exists('g:trans_bin')
    let g:trans_bin = ""
endif
if !exists('g:trans_default_direction')
    let g:trans_default_direction = ""
endif
if !exists('g:trans_directions_list')
    let g:trans_directions_list = []
endif
if !exists('g:trans_interactive_full_list')
    let g:trans_interactive_full_list = 0
endif
if !exists('g:trans_advanced_options')
    let g:trans_advanced_options = ""
endif
if !exists('g:trans_win_width')
    let g:trans_win_width = 50
endif
if !exists('g:trans_win_height')
    let g:trans_win_height = 15
endif
if !exists('g:trans_win_position')
    let g:trans_win_position = 'bottom'
endif
if !exists('g:trans_join_lines')
    let g:trans_join_lines = 0
endif
if !exists('g:trans_save_history')
    let g:trans_save_history = 0
endif
if !exists('g:trans_history_file')
    let g:trans_history_file = ''
endif
if !exists('g:trans_history_format')
    let g:trans_history_format = '%s;%t'
endif
if !exists('g:trans_close_window_after_saving')
    let g:trans_close_window_after_saving = 0
endif
if !exists('g:trans_save_only_unique')
    let g:trans_save_only_unique = 0
endif
if !exists('g:trans_save_audio')
    let g:trans_save_audio = 0
endif
if !exists('g:trans_ignore_audio_for_langs')
    let g:trans_ignore_audio_for_langs = []
endif
if !exists('g:trans_save_raw_history')
    let g:trans_save_raw_history = 0
endif
if !exists('g:trans_history_raw_file')
    let g:trans_history_raw_file = '~/.vim/.trans_raw_history'
endif
" }}} Default configuration "
" Commands {{{ "
command! -nargs=* TransTerm call trans#TransTerm(<f-args>)
command! -nargs=* -range Trans call trans#Trans(<line1>, <line2>, <count>, <f-args>)
command! -nargs=0 -range TransSelectDirection call trans#TransSelectDirection(0, <line1>, <line2>, <count>)
command! -nargs=* TransInteractive call trans#TransInteractive(0, <f-args>)
command! -nargs=0 TransOpenHistoryWindow call trans#TransOpenHistoryWindow()
command! -nargs=0 TransChangeDefaultDirection call trans#TransChangeDefaultDirection()
" }}} Commands "

