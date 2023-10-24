class LikesController < ApplicationController
    before_action :can_login_user
    def create 
        @post_id = params[:post_id]
        @user_id = current_user.id

        @like = Like.new(user_id: @user_id, post_id: @post_id)
        if @like.save
            redirect_to posts_path
        else
            redirect_to posts_path, notice: "いいねの追加に失敗しました。"
        end
    end

    def destroy
        @like = Like.find(params[:id])
        if @like.destroy
            redirect_to posts_path
        else
            redirect_to posts_path, notice: "いいねの削除に失敗しました。"
        end
    end
end
