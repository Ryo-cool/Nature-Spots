require 'rails_helper'
RSpec.describe User, type: :model do
  it '正常テスト' do
    @user = User.new(
      name: "user", email: "kkk@gmail.com", password_digest: "00000000"
    )
    expect(@user).to be_valid
  end
end
