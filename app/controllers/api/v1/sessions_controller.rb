class Api::V1::SessionsController < Api::V1::BaseController
	def create
		user = User.find_by(email: session_params[:email])

		if user and user.valid_password?(session_params[:password])
			sign_in user, store: false #sign_in helper do devise e store: false mostra que não ira ser criado uma sessao.
			user.generate_authentication_token!
			user.save!
			render json: user, status: 200
		else
			render json: { errors: 'Invalid password or email'}, status: 401
		end
	end

	def destroy
		user = User.find_by(auth_token: params[:id])
		user.generate_authentication_token!
		user.save
		head 204
	end

	private

	def session_params
		params.require(:session).permit(:email, :password)
	end
end
