class LikesController < ApplicationController
    before_action :can_login_user
    def create 
        @like = Like.new(user_id: current_user.id, post_id: params[:post_id])
        @like.save!
        redirect_to posts_path
    end

    def destroy
        @like = Like.find(params[:id])
        @like.destroy!
        redirect_to posts_path
    end
end
