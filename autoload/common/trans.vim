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

function! common#trans#GetLanguagesList()
    return sort(values(s:trans_supported_languages_dict))
endfunction

function! common#trans#GetCodesList()
    return sort(keys(s:trans_supported_languages_dict))
endfunction

function! common#trans#GetLanguagesDict()
    let lang_dict = {}
    for [key, item] in items(s:trans_supported_languages_dict)
        let lang_dict[item] = key
    endfor
    return lang_dict
endfunction

function! common#trans#GetCodesDict()
    return s:trans_supported_languages_dict
endfunction

function! common#trans#GetPathToBin()
    let cmd = ""
    if strlen(g:trans_bin) > 0
        let cmd = g:trans_bin."/"
        let cmd = expand(cmd)
    endif
    return cmd
endfunction

function! common#trans#GenerateCMD(args, ...)
    call s:getTranslateLanguages(a:args)
    let cmd = common#trans#GetPathToBin()
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

function! common#trans#GenerateCMDForDownloadAudio(file, language, text)
    let text = "\"".a:text."\""
    let cmd = common#trans#GetPathToBin()
    let cmd = cmd."trans -download-audio-as=".a:file
    let cmd = cmd." :".a:language." ".text
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

function! common#trans#GenerateArgs(args)
    let args = ""
    if len(a:args) > 0
        for arg in a:args
            let args = args." ".arg
        endfor
    endif
    let is_direction_in_args = match(args, '\v[a-z-]*:[a-z-]*')
    if is_direction_in_args == -1
        let args = args." ".g:trans_default_direction
    endif
    return args
endfunction

function! common#trans#GetHumanDirectionsList()
    let human_directions_list = []
    for direction in g:trans_directions_list
        let str = "["
        let i = 0
        for lang in direction
            if strlen(lang) > 0
                let langname = common#trans#GetCodesDict()[lang]
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

function! common#trans#GetItemsForInputlist()
    let human_directions_list = common#trans#GetHumanDirectionsList()
    return common#common#GenerateInputlist("Select languages:", human_directions_list)
endfunction

function! common#trans#GenerateTranslateDirection(direction_id)
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

function! common#trans#PrepareTextToTranslating(text)
    let escape_symbols = ["\"", "`"]
    let text = a:text
    for symbol in escape_symbols
        let text = escape(text, symbol)
    endfor
    let s:trans_current_source_text = text
    if g:trans_save_raw_history > 0
        call common#history#AppendTextToFile(g:trans_history_raw_file, text)
    endif
    let text = "\"".text."\""
    return text
endfunction

function! common#trans#GetCurrentSourceText()
    return s:trans_current_source_text
endfunction

function! common#trans#GetSourceLang()
    if strlen(s:trans_source_lang) > 0
        return s:trans_source_lang
    endif
    return common#trans#DetermineLang(s:trans_current_source_text)
endfunction

function! common#trans#GetTargetLang(text)
    if strlen(s:trans_target_lang) > 0 && len(split(s:trans_target_lang, '+')) == 1
        return s:trans_target_lang
    endif
    return common#trans#DetermineLang(a:text)
endfunction

function! common#trans#DetermineLang(text)
    let text = "\"".a:text."\""
    let cmd = common#trans#GenerateCMD("-id", text)
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

