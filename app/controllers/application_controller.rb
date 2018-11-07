class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "权限错误！"
    session[:return_to] ||= request.referer
    # redirect_to root_url
    redirect_to session.delete(:return_to)
  end
end
