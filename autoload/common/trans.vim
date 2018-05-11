" ============================================================================
" File:        trans.vim
" Description: Common functions for translate
" Maintainer:  Egor Churaev <egor.churaev@gmail.com>
" Licence:     GPLv3
"
" ============================================================================

let s:trans_default_options = "-no-theme -no-ansi" " TODO: -dump

" List of languages supported by translate-shell
let s:trans_supported_languages_dict = {
    \'':         'Autodetect',
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

function! common#trans#generateCMD(...)
    let cmd = ""
    if strlen(g:trans_bin) > 0
        let cmd = g:tran_bin."/"
    endif
    let cmd = "trans ".s:trans_default_options." ".g:trans_advanced_options
    for arg in a:000
        let cmd = cmd." ".arg
    endfor
    return cmd
endfunction

function! common#trans#getHumanDirectionsList()
    let human_directions_list = []
    for direction in g:trans_directions_list
        let str = "["
        let i = 0
        for lang in direction
            if i == 0
                let str = str."".s:trans_supported_languages_dict[lang]." -> "
            elseif i == 1
                let str = str."".s:trans_supported_languages_dict[lang]
            else
                let str = str.", ".s:trans_supported_languages_dict[lang]
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

