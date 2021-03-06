require 'rails_helper'
RSpec.describe User, type: :model do
  it '正常テスト' do
    @user = User.new(
      name: "user", email: "kkk@gmail.com", password_digest: "00000000"
    )
    expect(@user).to be_valid
  end
end
# describe User do
#   describe '#create' do
#     it "nicknameがない場合は登録できないこと" do
#       user = User.new(name: "user", email: "kkk@gmail.com", password_digest: "00000000")
#       user.valid?
#       expect(user.errors[:name]).to include("can't be blank")
#     end
#   end
# end