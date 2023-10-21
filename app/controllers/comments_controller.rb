class CommentsController < ApplicationController
    before_action :can_login_user, only:[:new, :create]
    before_action :comment_only_login_user, only:[:edit, :update, :destroy]

    def new
        @comment = Comment.new
        @post_id = params[:post_id]
    end

    def create
        @comment = Comment.new(user_id: params[:user_id], 
                               post_id: params[:post_id],
                               comment: params[:comment])
        if @comment.save
            flash[:notice] = "コメントを送信しました。"
            redirect_to posts_path
        else
            render "new", status: :unprocessable_entity
        end
    end

    def edit

    end

    def update
        if @comment.update(comment: params[:comment])
            flash[:notice] = "コメントを編集しました。"
            redirect_to posts_path
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def destroy
        @comment.destroy
        flash[:notice] = "コメントを削除しました"
        redirect_to posts_path, status: :see_other
    end
end
