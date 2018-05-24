" ============================================================================
" File:        history.vim
" Description: Functions for saving translation to file
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

function! common#history#addTranslationToHistory(source, translation)
    if strlen(g:trans_history_file) == 0
        return "Error! g:trans_history_file not defined."
    endif
    let line = substitute(g:trans_history_format, "%s", a:source, 'g')
    let line = substitute(line, "%t", a:translation, 'g')
    let filename = s:getHistoryFileName(g:trans_history_file, a:translation)
    if g:trans_save_only_unique > 0
        let line_num = s:getLineNumWithText(filename, a:source)
        if line_num > 0
            if g:trans_save_only_unique == 1
                return "Error! Cannot add translation for '".a:source."' because it is already in ".g:trans_history_file
            endif
            call s:appendTranslationToFile(filename, line_num, a:translation)
            return filename
        endif
    endif

    if g:trans_save_audio > 0
        let directory = fnamemodify(filename, ":h")

        let source_audio = s:downloadAudioFile(directory, common#trans#getCurrentSourceText())
        if strlen(source_audio) > 0
            let source_audio = "[sound:".fnamemodify(source_audio, ":t")."]"
            let source_audio = substitute(source_audio, "'", "", "g")
        endif
        let line = substitute(line, "%as", source_audio, 'g')

        let trans_audio = s:downloadAudioFile(directory, a:translation)
        if strlen(trans_audio) > 0
            let trans_audio = "[sound:".fnamemodify(trans_audio, ":t")."]"
            let trans_audio = substitute(trans_audio, "'", "", "g")
        endif
        let line = substitute(line, "%at", trans_audio, 'g')
    endif

    call common#history#appendTextToFile(filename, line)

    return filename
endfunction

function! s:downloadAudioFile(directory, text)
    redraw | echo "Downloading audio for ".a:text."..."
    let lang = common#trans#determineLang(a:text)
    if index(g:trans_ignore_audio_for_langs, lang) > -1
        return ""
    endif
    let audio_file = s:getAudioFileName(a:directory, a:text)
    let cmd = common#trans#generateCMDForDownloadAudio(audio_file, lang, a:text)
    call system(cmd)
    redraw | echo "Downloading is done!"
    return audio_file
endfunction

function! s:getAudioFileName(directory, text)
    let file = a:directory."/".a:text.".mp3"
    let file = expand(file)
    let file = shellescape(file)
    return file
endfunction

function! s:getHistoryFileName(filename, translation)
    let filename = a:filename
    if g:trans_save_history > 1
        let filename = fnamemodify(a:filename, ":r")
        let file_ext = fnamemodify(a:filename, ":e")
        let filename = filename."_".common#trans#getSourceLang()
        if g:trans_save_history == 3
            let filename = filename."_".common#trans#getTargetLang(a:translation)
        endif
        if strlen(file_ext) > 0
            let filename = filename.".".file_ext
        endif
    endif
    return filename
endfunction

function! s:getLineNumWithText(filename, text)
    let filename = expand(a:filename)
    if !filereadable(filename)
        return 0
    endif
    let lines = readfile(filename)
    for i in range(0, len(lines) - 1)
        let line = lines[i]
        let find = match(line, a:text)
        if find > -1
            return i + 1
        endif
    endfor
    return 0
endfunction

function! common#history#appendTextToFile(filename, text)
    tabedit
    setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
    silent! put = a:text
    " Remove empty lines
    g/^$/d
    silent! execute 'w! >>' a:filename
    q
endfunction

function! s:appendTranslationToFile(filename, line_num, translation)
    let filename = expand(a:filename)
    if !filereadable(filename)
        return
    endif
    let lines = readfile(filename)
    " Change format to regex
    let regex = substitute(g:trans_history_format, "%s", ".*", "g")
    let regex = substitute(regex, "%t", "\\\\(.*\\\\)", "g")
    let regex = substitute(regex, "%as", ".*", "g")
    let regex = substitute(regex, "%at", ".*", "g")
    let lst = []
    call substitute(lines[a:line_num-1], regex, '\=add(lst, submatch(1))', 'g')
    if len(lst) == 0
        return
    endif
    let trans_from_file = lst[0]
    if match(trans_from_file, a:translation) > -1
        return
    endif
    let translation = trans_from_file.", ".a:translation
    let lines[a:line_num-1] = substitute(lines[a:line_num-1], trans_from_file, translation, "g")

    call writefile(lines, filename, "w")
endfunction

function! common#history#GetListOfHistoryFiles()
    if g:trans_save_history == 0
        return []
    endif
    if g:trans_save_history == 1
        return [g:trans_history_file]
    endif

    let history_list = []
    let path = fnamemodify(g:trans_history_file, ":h")
    let filename = fnamemodify(g:trans_history_file, ":t:r")
    let file_ext = fnamemodify(g:trans_history_file, ":e")
    if strlen(file_ext) == 0
        let pathlist = split(globpath(path, '*'), '\n')
    else
        let pathlist = split(globpath(path, '*.'.file_ext), '\n')
    endif
    if g:trans_save_history == 2
        let regexp = "^".filename."_[a-z\\-]\\+$"
    else
        let regexp = "^".filename."_[a-z\\-]\\+_[a-z\\-]\\+$"
    endif

    for file in pathlist
        let name = fnamemodify(file, ":t:r")
        if name =~ regexp
            call add(history_list, file)
        endif
    endfor
    return history_list
endfunction

