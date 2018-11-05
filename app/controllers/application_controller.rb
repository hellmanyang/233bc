class ApplicationController < ActionController::Base
    rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = "权限错误！"
      redirect_to root_url
    end
end
