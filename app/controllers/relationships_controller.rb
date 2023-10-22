class RelationshipsController < ApplicationController
    before_action :can_login_user

    def create 
        # フォローする機能を追加する
        user = User.find(params[:followed_id])
        current_user.follow(user)
        redirect_to "/users/#{user.id}"
    end

    def destroy
        # フォローを解除する機能を追加する
        user = Relationship.find(params[:id]).followed
        current_user.unfollow(user)
        redirect_to "/users/#{user.id}", status: :see_other
    end
end
