"=============================================================================
" Author: Jemma Nelson <pink.fwip@gmail.com>
" Author: Daniel Siepmann <coding@daniel-siepmann.de>
" License: BSD
" script type: plugin

if !exists("g:vim_jira_wrapper_command")
  let g:vim_jira_wrapper_command = "jira"
endif

" Grab issue
function! jira#GetIssue(id)
  silent !clear
  return split(system(g:vim_jira_wrapper_command . " issue " . a:id), '\r\n\|[\r\n]')[3:-2]
endfunction

" Grab command output
function! jira#SubmitCommand(command)
  silent !clear
  return split(system(g:vim_jira_wrapper_command . " " . a:command), '\r\n\|[\r\n]')[3:-2]
endfunction

" Open up a new split with the given JIRA Command
function! jira#Command(command)
  let tempfile = '/tmp/vim-jira-' . sha256(a:command) . '-desc.jira'
  call writefile(jira#SubmitCommand(a:command), tempfile)

  call jira#OpenBuffer(tempfile)
endfunction

" Open the given issue
function! jira#Issue(id)
  let tempfile = '/tmp/vim-jira-' . a:id . '-desc.jira'
  call writefile(jira#GetIssue(a:id), tempfile)

  call jira#OpenBuffer(tempfile)
endfunction

" Open up a new split with the given tempfile
function! jira#OpenBuffer(tempfile)
  execute 'vsplit ' . a:tempfile
  " Remove borders on first column and last. Afterwars strip trailing whitespace.
  execute '%s/^..//e | %s/ [^ ]*$//e | %s/┤$//e | %s/\s\+$//e'
  " Prevent writes
  execute 'setlocal buftype=nofile'
  execute 'normal! gg | normal! redraw!'
endfunction

" vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:smarttab
