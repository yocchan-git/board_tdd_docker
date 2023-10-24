class PostsController < ApplicationController
    before_action :post_only_login_user, only: [:edit, :update, :destroy]
    before_action :can_login_user, only: [:show, :new, :create]

    def index
        @q = Post.ransack(params[:q])
        @posts = @q.result.includes(:user).order("created_at desc")
    end

    def show
        @post = Post.find(params[:id])
    end

    def new
        @post = Post.new
    end

    def create 
        @post = Post.new(params_posts)
        @post.user_id = current_user.id

        if @post.save
            redirect_to posts_path, notice: "新規投稿を作成しました。"
        else
            render 'new', status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @post.update(params_posts)
            redirect_to post_path(@post), notice: "更新に成功しました。"
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def destroy
        @post.destroy
        redirect_to posts_path, status: :see_other, notice: "投稿が削除されました。"
    end

    private
        def params_posts
            params.require(:post).permit(:title, :content)
        end
end
