require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {build(:user)}

  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  it {is_expected.to validate_presence_of(:email)}
  it {is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:provider) }
  it {is_expected.to validate_confirmation_of(:password)}
  it {is_expected.to allow_value('teste@gmail.com').for(:email)}
  it {is_expected.to validate_uniqueness_of(:auth_token)}

  describe '#info' do

    it 'returns email, created at and token' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('abc123token')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: #{Devise.friendly_token}")
    end

  end

  describe '#Generate_authentication_token!' do

    it 'generates unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('abc123token')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('abc123token')
    end

    it 'generates another auth token  when current auth token already has been taken'  do
      allow(Devise).to receive(:friendly_token).and_return('primeirotokenparatestar', 'primeirotokenparatestar', 'segundotokenparatestar')
      existing_user = create(:user)
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
      
    
  end

  
end

