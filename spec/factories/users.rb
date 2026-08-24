# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  otp_secret             :string
#  consumed_timestep      :integer
#  otp_required_for_login :boolean          default(FALSE), not null
#  otp_backup_codes       :string           is an Array
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "motdepasse-test-123" }
    password_confirmation { "motdepasse-test-123" }
    otp_required_for_login { false }

    trait :with_two_factor do
      otp_required_for_login { true }
      otp_secret { User.generate_otp_secret }

      after(:create) do |user|
        user.generate_otp_backup_codes!
        user.save!
      end
    end
  end
end
