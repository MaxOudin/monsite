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
class User < ApplicationRecord
  # :two_factor_authenticatable remplace :database_authenticatable
  # (les charger ensemble permettrait de contourner le 2FA via Warden).
  devise :two_factor_authenticatable, :two_factor_backupable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  def otp_provisioning_issuer
    ENV.fetch("DOMAIN", "maximeoudin.fr")
  end
end
