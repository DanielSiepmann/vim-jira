if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'jira'
endif


highlight jiraMarkOn ctermfg=yellow guifg=yellow
highlight jiraMarkOff ctermfg=darkgrey guifg=darkgrey
highlight jiraMarkCheck ctermfg=green guifg=green
highlight jiraMarkError ctermfg=red guifg=red
highlight jiraMarkWarn ctermfg=202 guifg=#ff5f00
highlight jiraMarkYes ctermfg=green guifg=green
highlight jiraMarkNo ctermfg=red guifg=red
highlight jiraMarkInfo ctermfg=blue guifg=blue

highlight hide guifg=darkgrey ctermfg=darkgrey
highlight jiraBold gui=bold cterm=bold
highlight jiraItalic gui=italic cterm=underline

" TODO: Figure out how to make conceal chars the correct color
"
syntax match jiraMarkOn    /(on)/  " conceal cchar=⚙
syntax match jiraMarkOff   /(off)/ " conceal cchar=⚪
syntax match jiraMarkCheck /(\/)/  " conceal cchar=✔
syntax match jiraMarkError /(x)/
syntax match jiraMarkWarn  /(!)/   " conceal cchar=!
syntax match jiraMarkYes   /(y)/
syntax match jiraMarkNo    /(n)/
syntax match jiraMarkInfo  /(?)/
syntax cluster jiraMark contains=jiraMarkOn,jiraMarkOff,jiraMarkCheck,jiraMarkError,jiraMarkWarn,jiraMarkYes,jiraMarkNo

syntax match jiraStrong /\*[^*]\+\*/ excludenl contains=ALL
syntax match jiraEmphasis /_[^_]\+_/ excludenl contains=ALL
syntax match jiraCitation /??[^?]\+??/ excludenl contains=ALL
syntax match jiraDeleted /(\@<=^|\W)-[^-]\+-(\@<=\W|$)/ excludenl contains=ALL
syntax match jiraInserted /+[^+]\++/ excludenl contains=ALL
syntax match jiraSuperscript /^[^\^]\+^/ excludenl contains=ALL
syntax match jiraSubscript /\~[^\~]\+\~/ excludenl contains=ALL
syntax match jiraBlockquote /^bq\. .*/ excludenl contains=ALL
syntax region jiraQuote start="{quote}" end="{quote}" fold contains=ALL keepend
syntax region jiraQuote start="{quote:" end="{quote}" fold contains=ALL keepend
syntax region jiraQuoteTitle matchgroup=hide start="{quote:.\{-}\(title=\)" end="|.*}" contained
syntax match jiraQuoteEnd /{quote}/ contained
syntax region jiraColor start="{color}" end="{color}" fold contains=ALL keepend
syntax region jiraColor start="{color:" end="{color}" fold contains=ALL keepend
syntax region jiraColorTitle matchgroup=hide start="{color:.\{-}" end="|.*}" contained
syntax match jiraColorEnd /{color}/ contained

syntax match jiraHeading /^h[1-6]\. .*/ excludenl contains=ALL

syntax match jiraListMarker /^[*#]\+\s/

syntax region jiraNoFormat matchgroup=hide start="{noformat}" end="{noformat}" keepend

syntax region jiraPanel start="{panel:" end="{panel}" fold contains=ALL keepend
syntax region jiraPanelTitle matchgroup=hide start="{panel:.\{-}\(title=\)" end="|.*}" contained
syntax match jiraPanelEnd /{panel}/ contained

syntax region jiraCode start="{code}" end="{code}" fold contains=ALL keepend
syntax region jiraCode start="{code:" end="{code}" fold contains=ALL keepend
syntax region jiraCodeTitle matchgroup=hide start="{code:.\{-}\(title=\)" end="|.*}" contained
syntax match jiraCodeEnd /{code}/ contained

syntax region jiraTableHeader start="^\s*||" end="||\s*$" contains=ALL
syntax region jiraTableRow start="^\s*|" end="|\s*$" contains=ALL

" TODO doesn't handle ticket w/markup around it.
syntax match jiraTicketId /\<[A-Za-z]\+-[0-9]\+\>/

hi def link jiraStrong                    jiraBold
hi def link jiraEmphasis                  jiraItalic
hi def link jiraCitation                  jiraItalic
hi def link jiraDeleted                   Special
hi def link jiraInserted                  Underlined
hi def link jiraSuperscript               Special
hi def link jiraSubscript                 Special
hi def link jiraBlockquote                Comment
hi def link jiraQuoteTitle                Title
hi def link jiraQuoteEnd                  hide
hi def link jiraColorTitle                Title
hi def link jiraColorEnd                  hide

hi def link jiraHeading                   Title
hi def link jiraListMarker                Statement

hi def link jiraPanelTitle                Title
hi def link jiraPanelEnd                  hide
hi def link jiraCodeTitle                 Title
hi def link jiraCodeEnd                   hide
hi def link jiraCodeTitle                 Title
hi def link jiraCodeEnd                   hide
hi def link jiraTableHeader               jiraBold

hi def link jiraTicketId                  jiraBold

set foldmethod=syntax

let b:current_syntax="jira"
if main_syntax ==# 'jira'
  unlet main_syntax
endif

" vim:set sw=2 ts=2 sts=2:
