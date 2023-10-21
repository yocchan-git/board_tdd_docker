class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(name: params[:name],
                         email: params[:email],
                         password: params[:password])
        if @user.save
            reset_session
            login @user
            flash[:notice] = "新規登録に成功しました。"
            redirect_to posts_path
        else
            render 'new', status: :unprocessable_entity
        end
    end
end