class UsersController < ApplicationController
  def create
    user = User.create(user_params)

    if user.persisted?
      render json: user
    else
      render json: user.errors
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :age, :marketing_opt_in,
      address_attributes: [:street, :number, :postcode]
    )
  end
end
