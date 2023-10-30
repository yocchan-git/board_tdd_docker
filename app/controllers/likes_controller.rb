class LikesController < ApplicationController
    before_action :can_login_user
    def create 
        @like = Like.new(user_id: current_user.id, post_id: params[:post_id])
        @like.save!
        @post = Post.find(params[:post_id])
        respond_to do |format|
            format.html { redirect_to posts_path }
            format.turbo_stream
        end
    end

    def destroy
        @like = Like.find(params[:id])
        @post = Post.find(@like.post_id)
        @like.destroy!
        respond_to do |format|
            format.html { redirect_to posts_path }
            format.turbo_stream
        end
    end
end
