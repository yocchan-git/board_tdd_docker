class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      login @user
      redirect_to posts_path, notice: "ログイン成功"
    else
      flash[:notice] = "メールアドレスかパスワードが間違っています"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to login_path, status: :see_other, notice: "ログアウトしました。"
  end
end
