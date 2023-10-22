class UsersController < ApplicationController
    before_action :can_login_user, only:[:index, :show]
    before_action :edit_user_only_login_user, only:[:edit, :update]

    def index
        @users = User.all
    end

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

    def edit
    end

    def update
        if @user.update(name: params[:name], email: params[:email])
            flash[:notice] = "ユーザー情報を更新しました。"
            redirect_to "/users/#{@user.id}"
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def show
        @user = User.find(params[:id])
        @posts = Post.where(user_id: @user.id)
    end
end