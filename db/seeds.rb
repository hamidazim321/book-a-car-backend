# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


if Rails.env.development?
  user = User.find_or_initialize_by(name: 'test admin', email: "admin@gmail.com", admin: true)
  if user.new_record?
    user.password = "test12"
    user.save!
    puts "Seeded DB with test admin account"
  end
end

if Rails.env.production?
  admin = User.find_or_initialize_by(email: 'admin@example.com')
  admin.name = 'Admin User'
  admin.password = ENV['ADMIN_PASSWORD'] || 'default_secure_password'
  admin.admin = true
  admin.save!
  puts 'Seeded DB with admin account'
end