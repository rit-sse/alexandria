FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password  'password'
    user_name 'First Last'

    factory :distributor do
      role_id 3
    end

    factory :librarian do
      role_id 2
    end

    factory :patron do
      role_id 1
    end

    factory :technical_admin do
      role_id 4
    end
  end
end
