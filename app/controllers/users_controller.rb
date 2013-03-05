class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  private

  def create_chart
    users_by_day = User.group("DATE(created_at)").count
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date')
    data_table.new_column('number')
    users_by_day.each do |day|
      data_table.add_row([ Date.parse(day[0].to_s), day[1]])
  end
  @chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table)  
end