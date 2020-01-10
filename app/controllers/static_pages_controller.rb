class StaticPagesController < ApplicationController
  include StaticPagesHelper
  def help
  end

  def about
  end

  def contact
  end
  
  def home
    if logged_in?
      @micropost  = Micropost.all
      @feed_items = Micropost.paginate(page: params[:page], per_page: 20)
    else
      @micropost  = Micropost.all
      @feed_items = Micropost.paginate(page: params[:page], per_page: 20)
      @user = User.all
      @artist = recommend
    end
  end
end
