class AdminController < ApplicationController
  before_action :admin_check
  
  def user
    @user = User.find_by(id: params[:id])
  end
  
  def update_user
    @user = User.find_by(id: params[:id])
    
    if @user.update(user_params)
      flash[:success] = "Updated successfully!"
    else
      flash[:error] = "Updating failed!"
    end
    
    redirect_to '/admin/user/'
  end
  
  def delete_user
    @user = User.find_by(id: params[:id])
    
    @user.destroy
    
    flash[:success] = "User deleted!"
    
    redirect_to '/admin/user'
  end
  
  def new_user
    @user = User.new
  end
  
  def create_user    
    if (params[:user][:password].length == 0)
      flash[:error] = "Password cannot be empty!"
      redirect_to request.original_url
      return
    else
      @user = User.new(user_params)
      if @user.save
        flash[:success] = "Added successfully!"
      else
        flash[:error] = "Adding failed!"
      end
      redirect_to "/admin/user/"
    end
  end
  
  def submission
    @submission = Submission.find_by(id: params[:id])
    @user = User.find_by(email: @submission.email)
  end

  def all_contests
    @contests = Contest.all
  end
  
  def contest
    @contest = Contest.find_by(id: params[:id])
    @problem = Problem.where(contest_id: @contest.id)
  end
  
  def new_contest
    @contest = Contest.new
  end
  
  def create_contest
    @contest = Contest.new(contest_params)
    
    if @contest.save
      flash[:success] = "Added successfully!"
    else
      flash[:error] = "Adding failed!"
    end
    
    redirect_to "/admin/contest"
  end
  
  def update_contest
    @contest = Contest.find_by(id: params[:id])
    
    if @contest.update(contest_params)
      flash[:success] = "Updated successfully!"
    else
      flash[:error] = "Updating failed!"
    end
    
    redirect_to "/admin/contest/"
  end
  
  def delete_contest
    @contest = Contest.find_by(id: params[:id])
    @problem = Problem.where(contest_id: params[:id])
    
    @contest.destroy
    @problem.destroy_all
    
    flash[:success] = "Deleted contest!"
    
    redirect_to "/admin/contest"
  end
  
  def new_problem
    @problem = Problem.new
    @problem.contest_id = params[:id]
  end
  
  def create_problem
    @problem = Problem.new(problem_params)
    @problem.input.gsub!("\r", "")
    @problem.output.gsub!("\r", "")
    @problem.contest_id = params[:id]
    if @problem.save
      flash[:success] = "Added successfully!"
    else
      flash[:error] = "Adding failed!"
    end
    redirect_to "/admin/contest/view/#{params[:id]}"
  end
  
  def problem
    @problem = Problem.find_by(id: params[:id])
  end
  
  def update_problem
    @problem = Problem.find_by(id: params[:id])
    
    if @problem.update(problem_params)
	  @problem.input.gsub!("\r", "")
      @problem.output.gsub!("\r", "")
	  @problem.save
	
      flash[:success] = "Updated successfully!"
    else
      flash[:error] = "Updating failed!"
    end
    
    redirect_to "/admin/contest/view/#{@problem.contest_id}"
  end
    
  def delete_problem
    @problem = Problem.find_by(id: params[:id])
    
    @problem.destroy
    
    flash[:success] = "Problem deleted!"
    
    redirect_to "/admin/contest/"
  end
  
  private
  
  def admin_check
    unless current_user.admin?
      flash[:error] = "Access Denied!"
      redirect_to "/panel"
    end
  end
  
  def user_params
    if (params[:user][:password].length > 0)  
      return params.require(:user).permit(:first_name, :last_name, :email, :password)
    else
      return params.require(:user).permit(:first_name, :last_name, :email)
    end
  end
  
  def problem_params
    return params.require(:problem).permit(:contest_id, :title,:problem, :input, :output)
  end
  
  def contest_params
    return params.require(:contest).permit(:title, :begin_time, :end_time)
  end
end
