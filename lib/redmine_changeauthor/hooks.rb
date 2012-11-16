module RedmineChangeAuthor
  class ViewIssuesContextMenuStartHook < Redmine::Hook::ViewListener
    render_on(:view_issues_form_details_bottom, :partial => 'issues/changeauthor_button')
  end
end