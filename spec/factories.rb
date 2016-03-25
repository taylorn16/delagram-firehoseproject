FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "fakeEmail#{n}@gmail.com"
    end
    password 'abcd1234'
  end
end
