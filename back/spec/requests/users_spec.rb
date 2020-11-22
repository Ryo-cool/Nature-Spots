require 'rails_helper'

RSpec.describe User, type: :request do
  # frozen_string_literal: true

  require 'rails_helper'

  describe 'User' do
    before(:each) do
      @status_code_ok = 200
    end
    it 'ユーザーを表示' do
      @user = FactoryBot.create(:user)
      get '/api/v1/users/show/'
      # @json = JSON.parse(response.body)
      # responseの可否判定
      # expect(response.status).to eq(@status_code_ok)
    end
  end
end