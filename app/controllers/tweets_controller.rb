class TweetsController < ApplicationController
  # before_action :logged_in_user, only: [:edit, :update]
  # before_action :correct_user, only: [:edit, :update]
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
  private
  def tweet_params
    params.require(:tweet).permit(:title,:body,:user_id,:image)
  end



end
