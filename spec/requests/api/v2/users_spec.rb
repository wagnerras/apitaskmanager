require 'rails_helper'

RSpec.describe 'Users API', type: :request do

    let!(:user) {create(:user)}
    let(:user_id) {user.id}

    let(:headers) do
        {
            'Accept' => 'application/vnd.taskmanager.v2',
            'Content-type' => Mime[:json].to_s,
            'Authorization' => user.auth_token
        }
    end

    before {host! 'api.taskmanager.test'}

    describe 'Get /users/:id' do

        before do
            get "/users/#{user_id}", params: {}, headers: headers
        end

        context 'when user exists' do

            it 'returns the user' do
                expect(json_body[:id]).to eq(user_id)
            end
            
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end

        end


        context 'when user does not exist' do
            let(:user_id) {1000}

            it 'returns status code 404' do
                expect(response).to have_http_status(404)
            end

        end

    end

    describe 'Post /users' do
        before do
            post '/users', params: {user: user_params}.to_json, headers: headers
        end

        context 'when request params are valid' do
            let(:user_params) {FactoryGirl.attributes_for(:user)}

            it 'returns status status code 201' do
                expect(response).to have_http_status(201)
            end

            it 'return json data for created user' do
                expect(json_body[:email]).to eq(user_params[:email])     
            end
        end

        context 'when request params are invalid' do
            let(:user_params) {attributes_for(:user, email: 'invalidemail@')}

            it 'return status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'return json data for errors' do
                expect(json_body).to have_key(:errors)
            end
        end

    end

    describe 'Put /users/:id' do

        before do
            put "/users/#{user_id}", params: {user: user_params}.to_json, headers: headers
        end

        context 'when request params are valid' do

            let(:user_params) { {email: 'newtaskmanager@email.com'} }

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end

            it 'return json data for updated user' do
                expect(json_body[:email]).to eq(user_params[:email])
            end
        end

        context 'when request params are invalid' do

            let(:user_params) { {email: 'invalid_email@'} }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'return json data for errors' do
                expect(json_body).to have_key(:errors)
            end
        end
    end

    describe 'DELETE /users/:id' do

        before do
            delete "/users/#{user_id}", params: {}, headers: headers
        end

        it 'returns code 204' do
            expect(response).to have_http_status(204)
        end

        it 'removes user from database' do
            expect(User.find_by(id: user.id)).to be_nil
        end
    end

end