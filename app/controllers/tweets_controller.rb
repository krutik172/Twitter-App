class TweetsController < ApplicationController
  before_action :logged_in_user

  def index
    @tweets=Tweet.all.order('created_at DESC')
   end

  def show
    @tweet=Tweet.find(params[:id])
   end

  def new
    @tweet=Tweet.new
  end
   
  def create 
    @tweet=Tweet.new(tweet_params)
    @tweet.image.attach(params[:tweet][:image])
    if @tweet.save
      redirect_to @tweet
    else
      render :new
    end
  end
  
  def edit
    @tweet=Tweet.find(params[:id])
  end  

  def update
    @tweet=Tweet.find(params[:id])
    if session[:user_id]
      if @tweet.user.name == current_user.name

        if @tweet.update(tweet_params)
            redirect_to @tweet
        else
            render :edit
            
        end
      else
        render :edit
      end
     end
  end

  def destroy
    @tweet=Tweet.find(params[:id])
    @tweet.destroy
    redirect_to root_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    render 'show_follow'
end
def followers
    @title = "Followers"
    @user = User.find(params[:id])
    render 'show_follow'
end

def logged_in_user
  unless logged_in?
    redirect_to login_url
    flash[:danger] = "Please log in."
  end
end

  private
  def tweet_params
    params.require(:tweet).permit(:title,:body,:user_id,:image)
  end
end
