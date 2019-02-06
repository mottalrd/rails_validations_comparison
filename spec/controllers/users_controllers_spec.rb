require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#create' do
    let(:params) do
      { 
        user: { 
          email: 'customer@myapp.com',
          age: '39',
          marketing_opt_in: 'false',
          address_attributes: {
            street: 'Downing Street',
            number: '10',
            postcode: 'SW1A 2AB'
          }
        }
      }
    end

    let(:user_json) do
      {
        "age" => 39,
        "email" => "customer@myapp.com",
        "id" => 1,
        "marketing_opt_in" => false,
      }
    end

    it 'does create a user' do
      expect {
        post users_path, params: params
      }.to change(User, :count).from(0).to(1)
    end

    it 'does return a json representation' do
      post users_path, params: params

      expect(
        JSON.parse(response.body)
      ).to include(user_json)
    end

    context 'when marketing opt-in is invalid' do
      before do
        params[:user][:marketing_opt_in] = 'no please'
      end

      it 'does create a user' do
        expect {
          post users_path, params: params
        }.to change(User, :count).from(0).to(1)
      end

      it 'does return the user (but with unexpected opt in value)' do
        post users_path, params: params

        user_json["marketing_opt_in"] = true

        expect(
          JSON.parse(response.body)
        ).to include(user_json)
      end
    end

    context 'when email is invalid' do
      before do
        params[:user][:email] = 'nope'
      end

      it 'does not create a user' do
        post users_path, params: params

        expect(User.count).to eq(0)
      end

      it 'does return the errors' do
        post users_path, params: params

        expect(
          JSON.parse(response.body)
        ).to eq(
          "email" => ["is invalid"]
        )
      end
    end

    context 'when age is not a number' do
      before do
        params[:user][:age] = 'eighteen'
      end

      it 'does not create a user' do
        post users_path, params: params

        expect(User.count).to eq(0)
      end

      it 'does return the errors' do
        post users_path, params: params

        expect(
          JSON.parse(response.body)
        ).to eq(
          "age" => ["is not a number"]
        )
      end
    end

    context 'when age value is not allowed' do
      before do
        params[:user][:age] = 15
      end

      it 'does not create a user' do
        post users_path, params: params

        expect(User.count).to eq(0)
      end

      it 'does return the errors' do
        post users_path, params: params

        expect(
          JSON.parse(response.body)
        ).to eq(
          "age" => ["must be greater than or equal to 18"]
        )
      end
    end

    context 'when email already exists' do
      before do
        User.create(user_json)
      end

      it 'does not create a user' do
        expect {
          post users_path, params: params
        }.not_to change(User, :count)
      end

      it 'does return the errors' do
        post users_path, params: params

        expect(
          JSON.parse(response.body)
        ).to eq(
          "email" => ["must be unique"]
        )
      end
    end

    context 'when the postcode is invalid' do
      before do
        params[:user][:address_attributes][:postcode] = 'Nope'
      end

      it 'does not create a user' do
        post users_path, params: params

        expect(User.count).to eq(0)
      end

      it 'does return the errors' do
        post users_path, params: params

        expect(
          JSON.parse(response.body)
        ).to eq(
          {"address"=>["is invalid"], "address.postcode"=>["is invalid"]}
        )
      end
    end
  end
end
