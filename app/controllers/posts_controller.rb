class PostsController < ApplicationController
    before_action :post_only_login_user, only: [:edit, :update, :destroy]
    before_action :can_login_user, only: [:show, :new, :create]

    def index
        @posts = Post.order(created_at: :desc)
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
            flash[:notice] = "新規投稿を作成しました。"
            redirect_to posts_path
        else
            render 'new', status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @post.update(params_posts)
            flash[:notice] = "更新に成功しました。"
            redirect_to post_path(@post)
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def destroy
        @post.destroy
        flash[:notice] = "投稿が削除されました。"
        redirect_to posts_path, status: :see_other
    end

    private
        def params_posts
            params.require(:post).permit(:title, :content)
        end
end
