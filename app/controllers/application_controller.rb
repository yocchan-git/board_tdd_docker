class ApplicationController < ActionController::Base
    include SessionsHelper

    # ポストの編集などはログインかつ投稿した本人のみ
    def post_only_login_user
        if current_user
            @post = Post.find(params[:id])
            unless @current_user.id == @post.user_id
                flash[:notice] = "権限がありません。"
                redirect_to posts_path
            end
        else
            flash[:notice] = "権限がありません。"
            redirect_to login_path
        end
    end

    # コメントの編集などはログインかつ自分のみ
    def comment_only_login_user
        if current_user
            @comment = Comment.find(params[:id])
            unless @current_user.id == @comment.user_id
                flash[:notice] = "権限がありません。"
                redirect_to posts_path
            end
        else
            flash[:notice] = "権限がありません。"
            redirect_to login_path
        end
    end

    # ログインしているかのチェック
    def can_login_user
        unless current_user
            flash[:notice] = "権限がありません"
            redirect_to login_path
        end
    end
end
