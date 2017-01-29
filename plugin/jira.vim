"=============================================================================
" File: jira.vim
" Author: Jemma Nelson <pink.fwip@gmail.com>
" WebPage: http://github.com/Fwip/vim-jira
" License: BSD
" script type: plugin
"

if &cp || (exists('g:loaded_jira_vim') && g:loaded_jira_vim)
  finish
endif
let g:loaded_jira_vim = 1

command! -bang -nargs=* Jira call jira#Command(<q-args>)
command! -bang -nargs=* JiraIssue call jira#Issue(<q-args>)
