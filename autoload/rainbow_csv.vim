"==============================================================================
"  Description: rainbow csv
"               by Dmitry Ignatovich
"==============================================================================

let s:max_columns = exists('g:rcsv_max_columns') ? g:rcsv_max_columns : 20

func! s:lines_are_delimited(lines, delim)
    let fieldsNumber = len(split(a:lines[0], a:delim))
    if (fieldsNumber < 2 || fieldsNumber > s:max_columns)
        return 0
    endif
    for line in a:lines
        let nfields = len(split(line, a:delim)) 
        if (fieldsNumber != nfields)
            return 0
        endif
        let fieldsNumber = nfields
    endfor
    return 1
endfunc

func! s:auto_detect_delimiter(delimiters)
    let lastLineNo = min([line("$"), 10])
    if (lastLineNo < 5)
        return ''
    endif
    let sampled_lines = []
    for linenum in range(1, lastLineNo)
        call add(sampled_lines, getline(linenum))
    endfor
    for delim in a:delimiters
        if (s:lines_are_delimited(sampled_lines, delim))
            return delim
        endif
    endfor
    return ''
endfunc


let s:pairs = [
    \ ['darkred',     'darkred'],
    \ ['darkblue',    'darkblue'],
    \ ['darkgreen',   'darkgreen'],
    \ ['darkmagenta', 'darkmagenta'],
    \ ['darkcyan',    'darkcyan'],
    \ ['red',         'red'],
    \ ['blue',        'blue'],
    \ ['green',       'green'],
    \ ['magenta',     'magenta'],
    \ ['NONE',        'NONE'],
    \ ]

let s:pairs = exists('g:rcsv_colorpairs') ? g:rcsv_colorpairs : s:pairs
let s:delimiters = ['	', ',']
let s:delimiters = exists('g:rcsv_delimiters') ? g:rcsv_delimiters : s:delimiters


func! rainbow_csv#try_load()
    let delim = s:auto_detect_delimiter(s:delimiters)
    let b:rainbow_csv_delim = delim
    if (!len(delim))
        return
    endif

    call rainbow_csv#generate_syntax(delim)
endfunc


func! rainbow_csv#generate_syntax(delim)
    if (len(s:pairs) < 2)
        return
    endif

    for groupid in range(len(s:pairs))
        let match = 'column' . groupid
        let nextgroup = groupid + 1 < len(s:pairs) ? groupid + 1 : 0
        let cmd = 'sy match %s /%s[^%s]*/ nextgroup=column%d'
        exe printf(cmd, match, a:delim, a:delim, nextgroup)
        let cmd = 'hi %s ctermfg=%s guifg=%s'
        exe printf(cmd, match, s:pairs[groupid][0], s:pairs[groupid][1])
    endfor

    let cmd = 'sy match startcolumn /^[^%s]*/ nextgroup=column1'
    exe printf(cmd, a:delim)
    let cmd = 'hi startcolumn ctermfg=%s guifg=%s'
    exe printf(cmd, s:pairs[0][0], s:pairs[0][1])
endfunc


func! rainbow_csv#manual_load()
    let delim = getline('.')[col('.') - 1]  
    let b:rainbow_csv_delim = delim
    call rainbow_csv#generate_syntax(delim)
endfunc


func! rainbow_csv#disable()
    syntax clear
    let b:rainbow_csv_delim = ''
endfunc
