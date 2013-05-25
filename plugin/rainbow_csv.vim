"==============================================================================
"  Description: rainbow csv
"               by Dmitry Ignatovich
"==============================================================================

func! s:TryLoadHighlighting()
    "caching
    if exists("b:rainbow_csv_delim") && len(b:rainbow_csv_delim)
        call rainbow_csv#generate_syntax(b:rainbow_csv_delim)
        return
    endif
    if exists("g:disable_rainbow_csv_autodetect")
        return
    endif
    if exists("b:current_syntax")
        return
    endif
    if (!exists("b:rainbow_csv_delim"))
        call rainbow_csv#try_load()
    endif
endfunc

autocmd BufEnter * call s:TryLoadHighlighting()
command RainbowDelim call rainbow_csv#manual_load()
command NoRainbowDelim call rainbow_csv#disable()
