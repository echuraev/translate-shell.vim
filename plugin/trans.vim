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
if !exists('g:trans_raw_history_file')
    let g:trans_history_raw_file = '~/.vim/.trans_raw_history'
endif
    let g:trans_save_history = 2 " 1, 2 and 3 are possible values
    let g:trans_history_file = '~/Desktop/trans_history.csv'
    let g:trans_close_window_after_saving = 1
    let g:trans_save_only_unique = 2 " 1 and 2 are possible values
    let g:trans_history_format = '%s;%t;%as;%at'
    let g:trans_save_raw_history = 1
    let g:trans_save_audio = 1
    let g:trans_ignore_audio_for_langs = ['ru']
" }}} Default configuration "
" Commands {{{ "
command! -nargs=* TransTerm call trans#TransTerm(<f-args>)
command! -nargs=* Trans call trans#Trans(<f-args>)
command! -nargs=0 TransSelectDirection call trans#TransSelectDirection()
command! -nargs=* TransInteractive call trans#TransInteractive(<f-args>)
command! -nargs=* -range TransVisual call trans#TransVisual(<f-args>)
command! -nargs=0 -range TransVisualSelectDirection call trans#TransVisualSelectDirection()
command! -nargs=0 TransOpenHistoryWindow call trans#TransOpenHistoryWindow()
" }}} Commands "

