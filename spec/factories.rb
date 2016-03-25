FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "fakeEmail#{n}@gmail.com"
    end
    password 'abcd1234'
  end

  factory :gram do
    message 'hello'
    photo {fixture_file_upload(Rails.root.join('spec', 'fixtures', 'pier.jpg'), 'image/jpg')}
    association :user
  end

  factory :comment do
    text 'Sample comment'

    association :user
    association :gram
  end
end
