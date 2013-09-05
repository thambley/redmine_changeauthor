class ChangeauthorController < ApplicationController
  unloadable
  before_filter :find_project, :authorize
  
  def index
    
    @users = @project.member_principals.find(:all, :include => [:roles, :principal], :order => "firstname", :conditions => "#{Principal.table_name}.type='User'")

    @issue_user=User.find(@issue["author_id"])
    
  end

    
  def edit
    
    author_before_change = @issue.author_id
    author_after_change = params[:authorid]
    
    if author_before_change != author_after_change
      
      if @issue.update_attribute(:author_id, author_after_change)
      
        flash[:notice] = l(:notice_successful_update)

        # journal attribute change
        if Setting.plugin_redmine_changeauthor["redmine_changeauthor_log_setting"].to_s == "yes"
          author_journal = Journal.new(:journalized => @issue, :user => User.current)
          author_journal.details << JournalDetail.new(:property => 'attr', :prop_key => :author_id, :old_value => author_before_change, :value => author_after_change)
          author_journal.save
        end
        
        redirect_to :controller => "issues", :action => "show", :id => params[:issue_id]
      else
        redirect_to :controller => "changeauthor", :action => "edit", :id => params[:issue_id]
      end
      
    else
    
      flash[:notice] = ("Author not updated")
      redirect_to :controller => "issues", :action => "show", :id => params[:issue_id]
      
    end
    
  end
 
  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @issue=Issue.find_by_id(params[:issue_id])
    @project = Project.find(@issue.project_id)
  end
end
