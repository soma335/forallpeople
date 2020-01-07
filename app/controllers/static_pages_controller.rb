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
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    else
      @micropost = Micropost.paginate(page: params[:page], per_page: 20)
      @user = User.all
      @artist = recommend
    end
  end
end
