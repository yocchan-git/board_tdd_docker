class ApplicationController < ActionController::Base
    include SessionsHelper

    # ポストの編集などはログインかつ投稿した本人のみ
    def post_only_login_user
        @post = Post.find(params[:id])
        current_user_check(@post,posts_path)
    end

    # コメントの編集などはログインかつ自分のみ
    def comment_only_login_user
        @comment = Comment.find(params[:id])
        current_user_check(@comment,posts_path)
    end

    # ユーザーの編集はログインかつ自分のみ
    def edit_user_only_login_user
        @user = User.find(params[:id])
        if current_user
            unless @current_user.id == @user.id
                redirect_to "/users/#{@user.id}", notice: "権限がありません。"
            end
        else
            redirect_to login_path, notice: "権限がありません。"
        end
    end

    # ログインしているかのチェック
    def can_login_user
        unless current_user
            redirect_to login_path, notice: "権限がありません。"
        end
    end

    def not_login_user
        if current_user
            redirect_to posts_path, notice: "すでにログインしています。"
        end
    end

    private
        def current_user_check(name, path)
            if current_user
                unless @current_user.id == name.user_id
                    redirect_to path, notice: "権限がありません。"
                end
            else
                redirect_to login_path, notice: "権限がありません。"
            end
        end
end
