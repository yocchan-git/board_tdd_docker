class CommentsController < ApplicationController
    before_action :can_login_user, only:[:new, :create]
    before_action :comment_only_login_user, only:[:edit, :update, :destroy]

    def new
        @comment = Comment.new
        @post_id = params[:post_id]
    end

    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(user_id: params[:user_id], 
                                        comment: params[:comment])
        if @comment.save
            redirect_to posts_path, notice: "コメントを送信しました。"
        else
            @post_id = params[:post_id]
            render "new", status: :unprocessable_entity
        end
    end

    def edit

    end

    def update
        if @comment.update(comment: params[:comment])
            redirect_to posts_path, notice: "コメントを編集しました。"
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def destroy
        @comment.destroy
        redirect_to posts_path, status: :see_other, notice: "コメントを削除しました。"
    end
end
