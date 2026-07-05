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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it "a une factory valide" do
    expect(build(:user)).to be_valid
  end

  describe "validations Devise" do
    it "exige un email" do
      expect(build(:user, email: "")).not_to be_valid
    end

    it "exige un mot de passe" do
      expect(build(:user, password: nil, password_confirmation: nil)).not_to be_valid
    end

    it "refuse un email dupliqué" do
      create(:user, email: "admin@example.com")
      expect(build(:user, email: "admin@example.com")).not_to be_valid
    end
  end

  describe "longueur du mot de passe (durcissement : 12..128)" do
    it "refuse un mot de passe de moins de 12 caractères" do
      expect(build(:user, password: "a" * 11, password_confirmation: "a" * 11)).not_to be_valid
    end

    it "accepte un mot de passe de 12 caractères ou plus" do
      expect(build(:user, password: "a" * 12, password_confirmation: "a" * 12)).to be_valid
    end
  end
end
