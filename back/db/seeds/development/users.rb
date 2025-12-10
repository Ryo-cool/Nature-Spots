guest = User.find_or_initialize_by(email: "guest@example.com")
if guest.new_record?
  guest.name = "ゲスト"
  guest.password = "Password1"
  guest.activated = true
  guest.save!
end

10.times do |n|
  name = "user#{n}"
  email = "#{name}@example.com"
  user = User.find_or_initialize_by(name: name, email: email, activated: true)

  if user.new_record?
    user.password = "Password1"
    user.save!
  end
end

puts "users = #{User.count}"