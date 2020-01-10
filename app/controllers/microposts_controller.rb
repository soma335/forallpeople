class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  skip_before_action :verify_authenticity_token
  
  def new
    @micropost = current_user.microposts.new
    @feed_items = current_user.feed.paginate(page: params[:page])
  end


  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture, :song, :artist, :like)
    end

    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end