if exists('b:loaded_arc_diff_jira_issue')
    finish
endif

let b:loaded_arc_diff_jira_issue = 1

function! s:InsertEmptyPlan() abort
    call cursor(1, 1)
    if search('^Test Plan:\s*\S')
        " Field has been already populated
        return
    endif
    if search('^Test Plan:', 'e')
        normal A-
    endif
endfunction

function! s:InsertIssueId() abort
    call cursor(1, 1)
    if search('^JIRA Issues:\s*\S')
        " Field has been populated
        return
    endif
    let branch = system("git rev-parse --abbrev-ref HEAD")
    let issue_id = substitute(branch, '^\([^-]\+-\d\+\)*-*.*', '\1', '')
    if empty(issue_id)
        echoerr "arcanistdiff: failed to parse issue id from branch name."
        return
    endif
    if search('^JIRA Issues:', 'e')
        execute 'normal A' . issue_id
    endif
    return issue_id
endfunction

call s:InsertEmptyPlan()
let b:issue_id = s:InsertIssueId()
call cursor(1, 1)
if !empty(b:issue_id)
    " Start commit message with jira issue and project name
    let b:project_name = fnamemodify(execute('pwd'), ':t')
    execute 'normal i' . b:issue_id . ' (' . b:project_name . ') '
endif
