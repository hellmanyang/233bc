class RolesController < ApplicationController
  # before_action :set_book, only: [:show, :edit, :update, :destroy]
  # before_action :authenticate_user!, only: [:new, :create]
  
  def new
    
  end
  
  def create
    unless params[:token] == '37608635'
      flash[:error] = '权限错误'
      redirect_to '/roles/new'
      return false
    end
    
    user = User.find_by email: params[:email]
    unless user.present?
      flash[:error] = '查找用户错误！'
      redirect_to '/roles/new'
      return false
    end
    
    case params[:role]
    when 'user'
      user.user!
      flash[:success] = "授权给#{user.email}以user的角色成功！"
    when 'vip'
      user.vip!
      flash[:success] = "授权给#{user.email}以vip的角色成功！"
    when 'admin'
      user.admin!
      flash[:success] = "授权给#{user.email}以admin的角色成功！"
    end
    
    redirect_to '/roles/new'
  end
end
