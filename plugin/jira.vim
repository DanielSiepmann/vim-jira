"=============================================================================
" Author: Jemma Nelson <pink.fwip@gmail.com>
" Author: Daniel Siepmann <coding@daniel-siepmann.de>
" License: BSD
" script type: plugin

if &cp || (exists('g:loaded_jira_vim_wrapper') && g:loaded_jira_vim_wrapper)
  finish
endif
let g:loaded_jira_vim_wrapper = 1

command! -bang -nargs=* Jira call jira#Command(<q-args>)
command! -bang -nargs=* JiraIssue call jira#Issue(<q-args>)
