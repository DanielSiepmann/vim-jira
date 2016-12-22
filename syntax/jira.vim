" Quit when a syntax file was already loaded
if exists("b:current_syntax")
    finish
endif

if !exists('main_syntax')
    let main_syntax = 'jira'
endif

syn match jiraLineStart "^[<@]\@!" nextgroup=@jiraBlock,htmlSpecialChar

syn cluster jiraBlock contains=jiraHeading,jiraBlockquote,jiraListMarker,jiraCodeBlock,jiraRule
syn cluster jiraInline contains=jiraLineBreak,jiraLinkText,jiraItalic,jiraBold,jiraBoldItalic,jiraStrikethrough,jiraCode,jiraEscape,@htmlTop,jiraError

highlight jiraBold term=bold cterm=bold gui=bold
highlight jiraItalic term=italic cterm=italic gui=italic
highlight jiraBoldItalic term=bold,italic cterm=bold,italic gui=bold,italic
highlight jiraStrikethrough gui=italic cterm=italic guifg=#888888 ctermfg=darkgrey

" TODO: Figure out how to make conceal chars the correct color

syntax match jiraMarkSmile	/:)/
syntax match jiraMarkSad	/:(/
syntax match jiraMarkTongue	/:P/
syntax match jiraMarkBigGrin	/:D/
syntax match jiraMarkWink	/;)/
syntax match jiraMarkYes	/(y)/
syntax match jiraMarkNo		/(n)/
syntax match jiraMarkInfo	/(i)/
syntax match jiraMarkCheck	/(\/)/  " conceal cchar=✔
syntax match jiraMarkError	/(x)/
syntax match jiraMarkWarn	/(!)/   " conceal cchar=!
syntax match jiraMarkAdd	/(+)/
syntax match jiraMarkRemove	/(-)/
syntax match jiraMarkHelp	/(?)/
syntax match jiraMarkOn		/(on)/  " conceal cchar=⚙
syntax match jiraMarkOff	/(off)/ " conceal cchar=⚪
syntax match jiraMarkStarYellow	/(\*)/
syntax match jiraMarkStarRed	/(\*r)/
syntax match jiraMarkStarGreen	/(\*g)/
syntax match jiraMarkStarBlue	/(\*b)/
syntax match jiraMarkStarYellow	/(\*y)/
syntax cluster jiraMark contains=jiraMarkSmile,jiraMarkSad,jiraMarkTongue,jiraMarkBigGrin,jiraMarkWink,jiraMarkYes,jiraMarkNo,jiraMarkInfo,jiraMarkCheck,jiraMarkError,jiraMarkWarn,
	\ jiraMarkAdd,jiraMarkRemove,jiraMarkHelp,jiraMarkOn,jiraMarkOff,jiraMarkStarYellow,jiraMarkStarRed,jiraMarkStarGreen,jiraMarkStarBlue

let s:concealends = has('conceal') ? ' concealends' : ''

function! s:jiraRegionSingleLine(name, char)
    " Jira region start happens:
    "	- SYMBOL at start of newline followed by nonspace
    "	- when nonword followed by SYMBOL followed by nonspace
    " Only works on single line (TODO how to express that)
    let l:charclass = '[' . a:char . '[:space:]]'
    let l:notcharclass = '[^' . a:char . '[:space:]]'
    exe 'syn match jira' . a:name
	\ . ' /\v'
		\ . '%(^|[^[:alnum:]]@<=)'
		\ . a:char
		\ . l:notcharclass . '+'
		\ . '%('
			\ . l:charclass . '+'
			\ . l:notcharclass . '+'
		\ . ')*'
		\ . a:char
		\ . '%($|[^[:alnum:]]@=)'
		\ . '/'
	\ . ' excludenl'
	\ . s:concealends
endfunction

function! s:jiraRegionMultiLine(name, char)
    " Jira region start happens:
    "	- SYMBOL at start of newline followed by nonspace
    "	- when nonword followed by SYMBOL followed by nonspace
    " Only works on single line (TODO how to express that)
    exe 'syn region jira' . a:name
	\ . ' start="'
		\ . '^'                . a:char . '[^' . a:char . '[:space:]]\@='
		\ . '\|'
		\ . '[^[:alnum:]]\@<=' . a:char . '[^' . a:char . '[:space:]]\@='
		\ . '"'
	\ . ' end="'
		\ . '[^' . a:char . '[:space:]]\@<=' . a:char . '[^' . a:char . '[:alnum:]]\@='
		\ . '\|'
		\ . '[^' . a:char . '[:space:]]\@<=' . a:char . '$'
		\ . '\|$'
		\ . '"'
	\ . ' keepend'
 	\ . ' contains=jiraStrong,jiraEmphasis,jiraStrongEmphasis,jiraCitation,jiraDeleted,jiraInserted,jiraSuperscript,jiraSubscript'
	\ . s:concealends
endfunction

call s:jiraRegionSingleLine('Strong',	    '\*')
call s:jiraRegionSingleLine('Emphasis',	    '_')
exe 'syn match jiraStrongEmphasis /\v%(^|[^[:alnum:]]@<=)%(\*_|_\*)[^_*[:space:]]+%([_*[:space:]]+[^_*[:space:]]+)*(\*_|_\*)%($|[^[:alnum:]]@=)/ excludenl ' . s:concealends
call s:jiraRegionSingleLine('Citation',	    '\?\?')
call s:jiraRegionSingleLine('Deleted',	    '-')
call s:jiraRegionSingleLine('Inserted',	    '\+')
call s:jiraRegionSingleLine('Superscript',    '\^')
call s:jiraRegionSingleLine('Subscript',	    '\~')
syntax match jiraBlockquote /^bq\. .*/ excludenl


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
" TAG
"


" values (inside tags)
"
" EXAMPLE:
"
" {tag:fooattribute = value | attr2 = value ...}
"                     ^^^^^           ^^^^^
syn match jiraAttribValue +[=]\@1<=[^|}]*\%([|}]\)\@=+
    \ contained
    \ display

" punctuation (within attributes)
"
" EXAMPLE:
"
" {tag:fooattribute = value | attr2 = value ...}
"     ^             ^       ^       ^
syn match   jiraAttribPunct +[=:|]+
    \ contained
    \ display

" attribute, everything before the '='
"
" PROVIDES: @jiraAttribHook
"
" EXAMPLE:
"
" {tag:fooattribute=value}
"      ^^^^^^^^^^^^
"
" eeeee zla [:|]\@1<=\<[a-zA-Z_][-.0-9a-zA-Z_]*\>\%([=|}]\@!\|$\)
"
"
"
syn match   jiraAttrib
    \ "[:|]\@1<=\<[a-zA-Z_][-.0-9a-zA-Z_]*\>"
    \ contained
    \ contains=@jiraAttribHook
    \ display

" tag name
"
" PROVIDES: @jiraTagNameHook
"
" EXAMPLE:
"
" {tag:fooattribute = value | attr2 = value ...}
"  ^^^
" {tag}
"  ^^^
"
syn match   jiraTagName
    \ "{\@1<=[^ {}:|]\+"
    \ contained
    \ contains=@jiraTagNameHook
    \ display

if exists('g:jira_syntax_folding')
    " highlight the end tag
    "
    " PROVIDES: @jiraEndTagHook
    "
    " EXAMPLE:
    "
    " {tag}
    " ^^^^^
    "
    " NOTE: highlighter can't distinguish between endtag/starttag.  Folding may not work.
    syn match   jiraEndTag
	\ "{[^ :|{}]\+}"
	\ contained
	\ contains=@jiraEndTagHook

    " start tag
    " use matchgroup=jiraTag to skip over the leading '{'
    "
    " PROVIDES: @jiraStartTagHook
    "
    " EXAMPLE:
    "
    " {tag:id=whoops}
    " s^^^^^^^^^^^^^e
    "
    syn region   jiraTag
	\ matchgroup=jiraTag start=+\%({\)@1<!{[^ :|{}]\@=+
	\ matchgroup=jiraTag end=+}+
	\ contained
	\ contains=jiraError,jiraTagName,jiraAttrib,jiraAttribPunct,jiraAttribValue,@jiraStartTagHook

    " tag elements with syntax-folding.
    " NOTE: NO HIGHLIGHTING -- highlighting is done by contained elements
    "
    " PROVIDES: @jiraRegionHook
    "
    " EXAMPLE:
    "
    " {tag:id=whoops}
    "   <!-- comment -->
    "   {anothertag}
    "   {anothertag}
    "   some data
    " </tag>
    "
    syn region   jiraRegion
	\ start=+{\z([^ :|{}]\+\)+
	\ skip=+<!--\_.\{-}-->+
	\ end=+{\z1\_\s\{-}}+
	\ matchgroup=jiraEndTag end=+/>+
	\ fold
	\ contains=jiraTag,jiraEndTag,jiraCdata,jiraRegion,jiraComment,jiraEntity,jiraProcessing,@jiraRegionHook,@Spell
	\ keepend
	\ extend

else
    " no syntax folding:
    " - contained attribute removed
    " - jiraRegion not defined
    "

    " highlight the end tag
    "
    " PROVIDES: @jiraEndTagHook
    "
    " EXAMPLE:
    "
    " {tag}
    " ^^^^^
    "
    " NOTE: highlighter can't distinguish between endtag/starttag.  Folding may not work.
    syn match   jiraEndTag
	\ "{[^ :|{}]\+}"
	\ contains=jiraTagName,@jiraEndTagHook

    " start tag
    " use matchgroup=jiraTag to skip over the leading '{'
    "
    " PROVIDES: @jiraTagHook
    "
    " EXAMPLE:
    "
    " {tag:id=whoops}
    " s^^^^^^^^^^^^^e
    "
    syn region   jiraTag
	\ matchgroup=jiraTag start=+{\%([^ :|{}][^}]*\)\@=+
	\ matchgroup=jiraTag end=+}+
	\ contains=jiraError,jiraTagName,jiraAttrib,jiraAttribPunct,jiraAttribValue,@jiraTagHook

endif



"
" noformat section (SPECIAL TAG)
"

if exists('g:jira_syntax_folding')
else
    " no syntax folding:
    " - contained attribute removed
    " - jiraRegion not defined
    "

    " highlight the end tag
    "
    " PROVIDES: @jiraEndTagHook
    "
    " EXAMPLE:
    "
    " {tag}
    " ^^^^^
    "
    " NOTE: highlighter can't distinguish between endtag/starttag.  Folding may not work.
    syn match   jiraNoformatTagEnd
	\ "{noformat}"
	\ contains=jiraTagName,@jiraEndTagHook

    " start tag
    " use matchgroup=jiraTag to skip over the leading '{'
    "
    " PROVIDES: @jiraTagHook
    "
    " EXAMPLE:
    "
    " {noformat:id=whoops}
    " s^^^^^^^^^^^^^^^^^^e
    "
    syn region   jiraNoformatTag
	\ matchgroup=jiraNoformatTag start=+{\%(noformat\>\)\@=+
	\ matchgroup=jiraNoformatTag end=+}+
	\ contains=jiraError,jiraTagName,jiraAttrib,jiraAttribPunct,jiraAttribValue,@jiraTagHook

endif

" PROVIDES: @jiraNoformatHook

syntax region jiraNoformat
    \ start=+{noformat[:}]+
    \ end=+{noformat}+
    \ contains=jiraNoformatTag,jiraNoformatTagEnd,@jiraNoformatHook,@Spell
    \ keepend
    \ extend

""syn match    jiraNoformatStart +{noformat}+         contained contains=jiraNoformatNoformat
""syn match    jiraNoformatStart +{noformat:[^}]*}+   contained contains=jiraNoformatNoformat,jiraAttrib,jiraAttribPunct,jiraAttribValue
""syn keyword  jiraNoformatNoformat noformat          contained
""


syntax match jiraHeading /^h[1-6]\. .*/ excludenl contains=ALL

syntax match jiraListMarker "^[-*#]\+\%(\s\)\@=" contained


syntax region jiraLink start="\[" end="\]" keepend contains=jiraLineStart

syntax match jiraNewline "\\\\" excludenl
syntax match jiraDash "--" excludenl
syntax match jiraDash "---" excludenl
syntax match jiraHorizontalRule "----" excludenl

syntax region jiraTableCell start="|\%([^|]\)\@=" end="\%(||\?\)\@=\|$" "contains=ALLBUT,jiraAttrib,jiraAttribPunct,jiraAttribValue
syntax region jiraTableHeaderCell start="||\%([^|]\)\@=" end="\%(||\?\)\@=\|$" "contains=ALLBUT,jiraAttrib,jiraAttribPunct,jiraAttribValue
syn match   jiraTablePunct +|+
    \ contained
    \ display

" TODO doesn't handle ticket w/markup around it.
syntax match jiraTicketId /\<[A-Z]\+-[0-9]\+\>/

syn region jiraCode matchgroup=jiraCodeDelimiter start="{{" end="}}" keepend


hi def debug1 guifg=Lime
hi def debug2 guifg=Fuchsia
hi def debug3 guifg=White	guibg=Lime
hi def debug4 guifg=White	guibg=Blue
hi def debug5 guifg=Blue	guibg=Red
hi def debug6 guifg=Orange	guibg=Gray

"
" HIGHLIGHTING
"
hi def link jiraStrong			jiraBold
hi def link jiraEmphasis		jiraItalic
hi def link jiraStrongEmphasis		jiraBoldItalic
hi def link jiraCitation		jiraItalic
hi def link jiraDeleted			jiraStrikethrough
hi def link jiraInserted		Underlined
hi def link jiraSuperscript		Special
hi def link jiraSubscript		Special
hi def link jiraBlockquote		Comment

hi def link jiraHeading			Title
hi def link jiraListMarker		Statement

hi def link jiraLink			Underlined

hi def jiraArg gui=bold guifg=darkRed
hi def link jiraValue			String

hi def link jiraTag			Function
hi def link jiraTagName			Function
hi def link jiraEndTag			Identifier

hi def link jiraAttribPunct		Comment
hi def link jiraAttribValue		String
hi def link jiraAttrib			Type

hi def link jiraCodeDelimiter		Delimiter


hi def link jiraNoformat		String
hi def link jiraNoformatTag		jiraTag
"hi def link jiraNoformatStart         Type
"hi def link jiraNoformatEnd           Type

hi def link jiraQuote			jiraTag
hi def link jiraQuoteTitle		Title
hi def link jiraQuoteEnd		jiraTag
hi def link jiraColor			jiraTag
hi def link jiraColorTitle		Title
hi def link jiraColorEnd		jiraTag
hi def link jiraPanel			jiraTag
hi def link jiraPanelTitle		Title
hi def link jiraPanelEnd		jiraTag
hi def link jiraCode			String

hi def link jiraTableHeaderCell         jiraBold
"hi def link jiraTableCell               jiraItalic
"hi def link jiraTablePunct		DiffText

hi def link jiraDash			Special
hi def link jiraHorizontalRule		Special
hi def link jiraNewline			Special

hi def link jiraTicketId		jiraLink

hi def jiraMarkSmile ctermfg=darkyellow guifg=darkyellow
hi def jiraMarkSad ctermfg=darkyellow guifg=darkyellow
hi def jiraMarkTongue ctermfg=darkyellow guifg=darkyellow
hi def jiraMarkBigGrin ctermfg=darkyellow guifg=darkyellow
hi def jiraMarkWink ctermfg=darkyellow guifg=darkyellow
hi def jiraMarkYes ctermfg=green guifg=green
hi def jiraMarkNo ctermfg=red guifg=red
hi def jiraMarkInfo ctermfg=blue guifg=blue
hi def jiraMarkCheck ctermfg=green guifg=green
hi def jiraMarkError ctermfg=red guifg=red
hi def jiraMarkWarn ctermfg=202 guifg=#ff5f00
hi def jiraMarkAdd ctermfg=green guifg=green
hi def jiraMarkRemove ctermfg=red guifg=red
hi def jiraMarkHelp ctermfg=blue guifg=blue
hi def jiraMarkOn ctermfg=yellow guifg=yellow
hi def jiraMarkOff ctermfg=darkgrey guifg=darkgrey
hi def jiraMarkStarYellow ctermfg=yellow guifg=yellow
hi def jiraMarkStarRed ctermfg=red guifg=red
hi def jiraMarkStarGreen ctermfg=green guifg=green
hi def jiraMarkStarBlue ctermfg=blue guifg=blue

set foldmethod=syntax

let b:current_syntax="jira"
if main_syntax ==# 'jira'
    unlet main_syntax
endif

" vim: sw=4 ts=8 sts=4 noexpandtab
