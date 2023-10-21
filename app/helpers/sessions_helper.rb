module SessionsHelper
    # ユーザーをログインさせる
    def login(user)
        session[:user_id] = user.id
    end

    # 現在のユーザーをログアウトする
    def log_out
        reset_session
        @current_user = nil   # 安全のため
    end

    # ログインしているユーザーを返す
    def current_user
        if session[:user_id]
            @current_user ||= User.find(session[:user_id])
        end
    end

    # ログインしているのか真偽値を返す
    def logged_in?
        !current_user.nil?
    end
end
