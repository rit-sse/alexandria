require 'bcrypt'
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password  'password'
    user_name 'First Last'

    factory :distributor do
      role_id 3
      barcode_hash BCrypt::Password::create('6666')
    end

    factory :librarian do
      role_id 2
      barcode_hash BCrypt::Password::create('7777')
    end

    factory :patron do
      role_id 1
      barcode_hash BCrypt::Password::create('5555')
    end

    factory :technical_admin do
      role_id 4
      barcode_hash BCrypt::Password::create('8888')
    end
  end
end
