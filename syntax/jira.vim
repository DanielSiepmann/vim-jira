if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'jira'
endif

syn match jiraLineStart "^[<@]\@!" nextgroup=@jiraBlock,htmlSpecialChar

syn cluster jiraBlock contains=jiraHeading,jiraBlockquote,jiraListMarker,jiraCodeBlock,jiraRule
syn cluster jiraInline contains=jiraLineBreak,jiraLinkText,jiraItalic,jiraBold,jiraCode,jiraEscape,@htmlTop,jiraError

highlight jiraMarkOn ctermfg=yellow guifg=yellow
highlight jiraMarkOff ctermfg=darkgrey guifg=darkgrey
highlight jiraMarkCheck ctermfg=green guifg=green
highlight jiraMarkError ctermfg=red guifg=red
highlight jiraMarkWarn ctermfg=202 guifg=#ff5f00
highlight jiraMarkYes ctermfg=green guifg=green
highlight jiraMarkNo ctermfg=red guifg=red
highlight jiraMarkInfo ctermfg=blue guifg=blue

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

syntax region jiraStrong start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" keepend contains=jiraLineStart
syntax region jiraEmphasis start="\S\@<=_\|_\S\@=" end="\S\@<=_\|_\S\@=" keepend contains=jiraLineStart
syntax region jiraCitation start="\S\@<=??\|??\S\@=" end="\S\@<=??\|??\S\@=" keepend contains=jiraLineStart
"syntax match jiraDeleted /\(\S\@<=-\|-\)[^-[:space:]][^-]*\(-\|-\S\@=\)/ excludenl
"syntax region jiraInserted start="\S\@<=+\|+\S\@=" end="\S\@<=+\|+\S\@=" keepend contains=jiraLineStart
syntax region jiraSuperscript start="\S\@<=\^\|\^\S\@=" end="\S\@<=\^\|\^\S\@=" keepend contains=jiraLineStart
syntax region jiraSuperscript start="\S\@<=\~\|\~\S\@=" end="\S\@<=\~\|\~\S\@=" keepend contains=jiraLineStart
syntax match jiraBlockquote /^bq\. .*/ excludenl

syn region  jiraString   contained start="{" end="}" contains=jiraSpecialChar,javaScriptExpression,@jiraPreproc
syn match   jiraValue    contained "=[\t ]*[^:|}]*"hs=s+1   contains=javaScriptExpression,@jiraPreproc
syn region  jiraEndTag             start="{"      end="}" contains=jiraTagN,jiraTagError
syn region  jiraTag                start="{"      end="}" fold contains=jiraTagN,jiraString,jiraArg,jiraValue,jiraTagError,jiraEvent,jiraCssDefinition,@jiraPreproc,@jiraArgCluster
syn match   jiraTagN     contained +{\s*[-a-zA-Z0-9]\++hs=s+1 contains=jiraTagName,jiraSpecialTagName,@jiraTagNameCluster
syn match   jiraTagError contained "[^}]{"ms=s+1


" tag names
syn keyword jiraTagName contained code color noformat panel quote

" arg names
syn keyword jiraArg contained title
syn match jiraArg contained "[a-zA-Z0-9]\+" " e.g. languages for code


"syntax region jiraQuote start="{quote}" end="{quote}" fold contains=ALL keepend
"syntax region jiraQuote start="{quote:" end="{quote}" fold contains=ALL keepend
"syntax region jiraQuoteTitle matchgroup=hide start="{quote:.\{-}\(title=\)" end="|.*}" contained
"syntax match jiraQuoteEnd /{quote}/ contained
"
"syntax region jiraColor start="{color}" end="{color}" fold contains=ALL keepend
"syntax region jiraColor start="{color:" end="{color}" fold contains=ALL keepend
"syntax region jiraColorTitle matchgroup=hide start="{color:.\{-}" end="|.*}" contained
"syntax match jiraColorEnd /{color}/ contained
"
"syntax region jiraNoFormat matchgroup=hide start="{noformat}" end="{noformat}" keepend
"
"syntax region jiraPanel start="{panel:[^}]*}" end="{panel}" fold contains=ALL keepend
"syntax region jiraPanelTitle matchgroup=hide start="{panel:.\{-}\(title=\)[^}]*}" end="|.*}" contained
"syntax match jiraPanelEnd /{panel}/ contained
"
"syntax region jiraCode start="{code}" end="{code}" fold contains=ALL keepend
"syntax region jiraCode start="{code:[^}]*}" end="{code}" fold contains=ALL keepend
"syntax match jiraCodeEnd /{code}/ contained


syntax match jiraHeading /^h[1-6]\. .*/ excludenl contains=ALL

syntax match jiraListMarker /^[-*#]\+\s/


syntax region jiraLink start="\[" end="\]" keepend contains=jiraLineStart

syntax match jiraNewline "\\\\" excludenl
syntax match jiraDash "--" excludenl
syntax match jiraDash "---" excludenl
syntax match jiraHorizontalRule "----" excludenl

syntax region jiraTableHeader start="^\s*||" end="||\s*$" contains=ALL
syntax region jiraTableRow start="^\s*|" end="|\s*$" contains=ALL

" TODO doesn't handle ticket w/markup around it.
syntax match jiraTicketId /\<[A-Z]\+-[0-9]\+\>/

hi def link jiraStrong                    jiraBold
hi def link jiraEmphasis                  jiraItalic
hi def link jiraCitation                  jiraItalic
hi def link jiraDeleted                   Special
hi def link jiraInserted                  Underlined
hi def link jiraSuperscript               Special
hi def link jiraSubscript                 Special
hi def link jiraBlockquote                Comment

hi def link jiraHeading                   Title
hi def link jiraListMarker                Statement

hi def link jiraLink                      Underlined

hi def link jiraTag                       Statement
hi def link jiraTagName                   htmlTagName
hi def jiraArg gui=bold guifg=darkRed
hi def link jiraValue                     String

hi def link jiraNoFormat                  jiraTag
hi def link jiraQuote                     jiraTag
hi def link jiraQuoteTitle                Title
hi def link jiraQuoteEnd                  jiraTag
hi def link jiraColor                     jiraTag
hi def link jiraColorTitle                Title
hi def link jiraColorEnd                  jiraTag
hi def link jiraPanel                     jiraTag
hi def link jiraPanelTitle                Title
hi def link jiraPanelEnd                  jiraTag
hi def link jiraCode                      jiraTag
hi def link jiraCodeTitle                 Title
hi def link jiraCodeEnd                   jiraTag
hi def link jiraCodeTitle                 Title
hi def link jiraCodeEnd                   jiraTag

hi def link jiraTableHeader               jiraBold

hi def link jiraDash                      Special
hi def link jiraHorizontalRule            Special
hi def link jiraNewline                   Special

hi def link jiraTicketId                  jiraLink

set foldmethod=syntax

let b:current_syntax="jira"
if main_syntax ==# 'jira'
  unlet main_syntax
endif

" vim:set sw=2 ts=2 sts=2:
