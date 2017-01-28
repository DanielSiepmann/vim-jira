"=============================================================================
" File: jira.vim
" Author: Jemma Nelson <pink.fwip@gmail.com>
" WebPage: http://github.com/Fwip/vim-jira
" License: BSD
" script type: plugin
"

" Prompt user if we need info
function! jira#GetCredentials()
  if !exists('g:vim_jira_url')
    let g:vim_jira_url = input("JIRA url? ")
  endif
  if !exists('g:vim_jira_user')
    let g:vim_jira_user = input("JIRA user? ")
  endif
  if !exists('g:vim_jira_pass')
    let g:vim_jira_pass = inputsecret("JIRA password? ")
  endif
  let g:vim_jira_rest_url = g:vim_jira_url . '/rest/api/2/'
endfunction

" Grab issue from the server
function! jira#GetIssue(id)
  call jira#GetCredentials()
  let url = g:vim_jira_rest_url . 'issue/' . a:id
  let cmd = 'curl '. url .' -s -k -u '. g:vim_jira_user .':'. g:vim_jira_pass

  let data_json = system(cmd)

  let g:jira_current_issue = json_encoding#Decode(data_json)

  return g:jira_current_issue
endfunction

" Extract an issue's description as an array of lines
function! jira#GetDesc(issue)
  " Can be encoded as \r\n, or \n. I put \r in there for safety
  return split(a:issue.fields.description, '\r\n\|[\r\n]')
endfunction

" Return path to issue, containing project category, project and issue name
function! jira#GetBreadcrumb(issue)
  return [
    \join([
      \"'",
      \a:issue.fields.project.projectCategory.name,
      \"' / '",
      \a:issue.fields.project.name,
      \"' / '",
      \a:issue.fields.summary,
      \"'",
    \],
    \""),
  \]
endfunction

" Return fields like in detail view of Jira
function! jira#GetFields(issue)
  return [
    \join(["Type: ",a:issue.fields.issuetype.name,],""),
    \join(["Priority: ",a:issue.fields.priority.name,],""),
    \join(["Status: ",a:issue.fields.status.name,],""),
  \]
endfunction

function! jira#CycleStatusIndicator()
  if (! exists('g:jira_status_icons'))
    let g:jira_status_icons = ['(off)', '(on)', '(/)', '(!)', '(?)', '(n)', '(y)']
  endif

  let word = expand('<cWORD>')
  let index = 0
  for i in g:jira_status_icons
    let index += 1
    if (i == word)
      let next_word = g:jira_status_icons[ index - len(g:jira_status_icons) ]
      execute 'normal! ciW' . next_word
    endif
  endfor
endfunction

function! jira#Browse()
  call jira#GetCredentials()
endfunction

" Open up a new split with the given issue
function! jira#OpenBuffer(id)
  let issue = jira#GetIssue(a:id)

  let tmpfile = '/tmp/vim-jira-' . issue.key . '-desc.jira'
  call writefile(
    \jira#GetBreadcrumb(issue)
    \+ [""]
    \+ jira#GetFields(issue)
    \+ [""]
    \+ jira#GetDesc(issue)
  \, tmpfile)
  execute 'vsplit ' . tmpfile
  " execute 'set ft=jira'
  let b:issue = issue
endfunction

" vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:smarttab
