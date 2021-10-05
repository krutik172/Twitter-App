class UsersController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update]
    before_action :correct_user, only: [:edit, :update]
    
    def index
        @user=User.all
        
    end

    def show
        @user=User.find(params[:id])
        @tweets = @user.tweets
        redirect_to root_url 

    end

    def new
        @user=User.new
    end

    def create
        
        @user=User.new(users_params)
        
        if @user.save
            @user.send_activation_email
            flash[:info] = "Please check your email to activate your account."
            redirect_to root_url
        else
            render :new
        end
    end

    def edit 
        @user=User.find(params[:id])
    end

     def update
        @user = User.find(params[:id])
        if @user.update(users_params)
          flash[:success] = "Profile was successfully updated"
          redirect_to @user
        else
          flash[:error] = "Something went wrong"
          render 'edit'
        end
    end
    def logged_in_user
        unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
        end
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless @user == current_user
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

    private

    def users_params
        params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

   
end
