class AuthController < ApplicationController

  def login

    if request.post?

      user = User.authenticate(params[:name], params[:password])

      if user
        flash.now[:notice] = "Login Efetuado"
        session[:user_id] = user.id
        redirect_to(:controller => "tickets", :action => "index")
      else
        flash.now[:alert] = "Combinação de usuário/senha inválida"
      end
    end

  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Desconectado"
    redirect_to(:action => "login")
  end

end
