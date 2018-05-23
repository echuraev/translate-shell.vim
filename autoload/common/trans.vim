" ============================================================================
" File:        trans.vim
" Description: Common functions for translate
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

let s:trans_default_options = "-no-theme -no-ansi" " TODO: -dump
let s:trans_current_source_text = ""
let s:trans_source_lang = ""
let s:trans_target_lang = ""

" List of languages supported by translate-shell
let s:trans_supported_languages_dict = {
    \'af':       'Afrikaans',
    \'am':       'Amharic',
    \'ar':       'Arabic',
    \'az':       'Azerbaijani',
    \'ba':       'Bashkir',
    \'be':       'Belarusian',
    \'bg':       'Bulgarian',
    \'bn':       'Bengali',
    \'bs':       'Bosnian',
    \'ca':       'Catalan',
    \'ceb':      'Cebuano',
    \'co':       'Corsican',
    \'cs':       'Czech',
    \'cy':       'Welsh',
    \'da':       'Danish',
    \'de':       'German',
    \'el':       'Greek',
    \'en':       'English',
    \'eo':       'Esperanto',
    \'es':       'Spanish',
    \'et':       'Estonian',
    \'eu':       'Basque',
    \'fa':       'Persian',
    \'fi':       'Finnish',
    \'fj':       'Fijian',
    \'fr':       'French',
    \'fy':       'Frisian',
    \'ga':       'Irish',
    \'gd':       'Scots Gaelic',
    \'gl':       'Galician',
    \'gu':       'Gujarati',
    \'ha':       'Hausa',
    \'haw':      'Hawaiian',
    \'he':       'Hebrew',
    \'hi':       'Hindi',
    \'hmn':      'Hmong',
    \'hr':       'Croatian',
    \'ht':       'Haitian Creole',
    \'hu':       'Hungarian',
    \'hy':       'Armenian',
    \'id':       'Indonesian',
    \'ig':       'Igbo',
    \'is':       'Icelandic',
    \'it':       'Italian',
    \'ja':       'Japanese',
    \'jv':       'Javanese',
    \'ka':       'Georgian',
    \'kk':       'Kazakh',
    \'km':       'Khmer',
    \'kn':       'Kannada',
    \'ko':       'Korean',
    \'ku':       'Kurdish',
    \'ky':       'Kyrgyz',
    \'la':       'Latin',
    \'lb':       'Luxembourgish',
    \'lo':       'Lao',
    \'lt':       'Lithuanian',
    \'lv':       'Latvian',
    \'mg':       'Malagasy',
    \'mhr':      'Eastern Mari',
    \'mi':       'Maori',
    \'mk':       'Macedonian',
    \'ml':       'Malayalam',
    \'mn':       'Mongolian',
    \'mr':       'Marathi',
    \'mrj':      'Hill Mari',
    \'ms':       'Malay',
    \'mt':       'Maltese',
    \'mww':      'Hmong Daw',
    \'my':       'Myanmar',
    \'ne':       'Nepali',
    \'nl':       'Dutch',
    \'no':       'Norwegian',
    \'ny':       'Chichewa',
    \'otq':      'Querétaro Otomi',
    \'pa':       'Punjabi',
    \'pap':      'Papiamento',
    \'pl':       'Polish',
    \'ps':       'Pashto',
    \'pt':       'Portuguese',
    \'ro':       'Romanian',
    \'ru':       'Russian',
    \'sd':       'Sindhi',
    \'si':       'Sinhala',
    \'sk':       'Slovak',
    \'sl':       'Slovenian',
    \'sm':       'Samoan',
    \'sn':       'Shona',
    \'so':       'Somali',
    \'sq':       'Albanian',
    \'sr-Cyrl':  'Serbian (Cyrillic)',
    \'sr-Latn':  'Serbian (Latin)',
    \'st':       'Sesotho',
    \'su':       'Sundanese',
    \'sv':       'Swedish',
    \'sw':       'Swahili',
    \'ta':       'Tamil',
    \'te':       'Telugu',
    \'tg':       'Tajik',
    \'th':       'Thai',
    \'tl':       'Filipino',
    \'tlh':      'Klingon',
    \'tlh-Qaak': 'Klingon (pIqaD)',
    \'to':       'Tongan',
    \'tr':       'Turkish',
    \'tt':       'Tatar',
    \'ty':       'Tahitian',
    \'udm':      'Udmurt',
    \'uk':       'Ukrainian',
    \'ur':       'Urdu',
    \'uz':       'Uzbek',
    \'vi':       'Vietnamese',
    \'xh':       'Xhosa',
    \'yi':       'Yiddish',
    \'yo':       'Yoruba',
    \'yua':      'Yucatec Maya',
    \'yue':      'Cantonese',
    \'zh-CN':    'Chinese Simplified',
    \'zh-TW':    'Chinese Traditional',
    \'zu':       'Zulu',
\}

function! common#trans#processPath(path)
    let path = a:path
    if strlen(path) > 0
        let path = substitute(path, "$HOME", $HOME, "g")
        let path = substitute(path, "\\~", $HOME, "g")
    endif
    return path
endfunction

function! common#trans#getPathToBin()
    let cmd = ""
    if strlen(g:trans_bin) > 0
        let cmd = g:trans_bin."/"
        let cmd = common#trans#processPath(cmd)
    endif
    return cmd
endfunction

function! common#trans#generateCMD(args, ...)
    call s:getTranslateLanguages(a:args)
    let cmd = common#trans#getPathToBin()
    let cmd = cmd."trans ".s:trans_default_options
    if strlen(g:trans_advanced_options) > 0
        let cmd = cmd." ".g:trans_advanced_options
    endif
    if strlen(a:args) > 0
        let cmd = cmd." ".a:args
    endif
    for arg in a:000
        let cmd = cmd." ".arg
    endfor
    return cmd
endfunction

function! s:getTranslateLanguages(args)
    let lst = []
    call substitute(a:args, '\([a-z]*\):\([a-z\+]*\)', '\=add(lst, [submatch(1), submatch(2)])', 'g')
    if len(lst) == 0
        return
    endif
    let s:trans_source_lang = lst[0][0]
    let s:trans_target_lang = lst[0][1]
endfunction

function! common#trans#generateArgs(default, args)
    let args = a:default
    if len(a:args) > 0
        let args = ""
        for arg in a:args
            let args = args." ".arg
        endfor
    endif
    return args
endfunction

function! common#trans#getHumanDirectionsList()
    let human_directions_list = []
    for direction in g:trans_directions_list
        let str = "["
        let i = 0
        for lang in direction
            if strlen(lang) > 0
                let langname = s:trans_supported_languages_dict[lang]
            else
                let langname = 'Autodetect'
            endif
            if i == 0
                let str = str."".langname." -> "
            elseif i == 1
                let str = str."".langname
            else
                let str = str.", ".langname
            endif
            let i += 1
        endfor
        let str = str."]"
        call add(human_directions_list, str)
    endfor
    return human_directions_list
endfunction

function! common#trans#getItemsForInputlist()
    let human_directions_list = common#trans#getHumanDirectionsList()
    let shown_items = ['Select languages:']
    for i in range(1, len(human_directions_list))
        call add(shown_items, i.'. '.human_directions_list[i-1])
    endfor
    return shown_items
endfunction

function! common#trans#generateTranslateDirection(direction_id)
    if len(g:trans_directions_list) == 0
        return ""
    endif
    if a:direction_id < 0 || a:direction_id >= len(g:trans_directions_list)
        return ""
    endif
    let direction = g:trans_directions_list[a:direction_id]
    let trans_direction = direction[0]
    let trans_dest = direction[1]
    for i in range(2, len(direction)-1)
        let trans_dest = trans_dest."+".direction[i]
    endfor
    let trans_direction = trans_direction.":".trans_dest
    return trans_direction
endfunction

function! common#trans#prepareTextToTranslating(text)
    let text = escape(a:text, "\"")
    let s:trans_current_source_text = text
    if g:trans_save_raw_history > 0
        call s:writeTextToFile(g:trans_history_raw_file, text)
    endif
    let text = "\"".text."\""
    return text
endfunction

function! common#trans#getCurrentSourceText()
    return s:trans_current_source_text
endfunction

function! common#trans#addTranslationToHistory(source, translation)
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
    call s:writeTextToFile(filename, line)
    return filename
endfunction

function! s:getHistoryFileName(filename, translation)
    let filename = a:filename
    if g:trans_save_history > 1
        let split_filename = split(filename, "\\.")
        let len_of_split_filename = len(split_filename)
        let file_ext = ""
        if len_of_split_filename > 2
            let filename = join(split_filename[0:(len_of_split_filename-2)])
            let file_ext = split_filename[len_of_split_filename-1]
        else
            let filename = split_filename[0]
            if len_of_split_filename == 2
                let file_ext = split_filename[1]
            endif
        endif
        let filename = filename."_".s:getSourceLang()
        if g:trans_save_history == 3
            let filename = filename."_".s:getTargetLang(a:translation)
        endif
        if strlen(file_ext) > 0
            let filename = filename.".".file_ext
        endif
    endif
    return filename
endfunction

function! s:getSourceLang()
    if strlen(s:trans_source_lang) > 0
        return s:trans_source_lang
    endif
    return s:determineLang(s:trans_current_source_text)
endfunction

function! s:getTargetLang(text)
    if strlen(s:trans_target_lang) > 0 && len(split(s:trans_target_lang, '+')) == 1
        return s:trans_target_lang
    endif
    return s:determineLang(a:text)
endfunction

function! s:determineLang(text)
    let text = "\"".a:text."\""
    let cmd = common#trans#generateCMD("-id", text)
    let ret_list = split(system(cmd), "\\n")
    let lang = ""
    for item in ret_list
        let spl = split(item, " ")
        if spl[0] == "Code"
            let lang = spl[-1]
        endif
    endfor
    return lang
endfunction

function! s:getLineNumWithText(filename, text)
    let filename = common#trans#processPath(a:filename)
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

function! s:writeTextToFile(filename, text)
    tabedit
    setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
    silent! put = a:text
    " Remove empty lines
    g/^$/d
    silent! execute 'w! >>' a:filename
    q
endfunction

function! s:appendTranslationToFile(filename, line_num, translation)
    let filename = common#trans#processPath(a:filename)
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

