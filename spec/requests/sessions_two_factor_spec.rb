# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions Devise (2FA)", type: :request do
  let(:password) { "motdepasse-test-123" }

  describe "POST /users/sign_in" do
    context "sans 2FA" do
      let(:user) { create(:user, password: password, password_confirmation: password) }

      it "connecte avec email et mot de passe" do
        post user_session_path, params: { user: { email: user.email, password: password } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "avec 2FA activé" do
      let(:user) { create(:user, :with_two_factor, password: password, password_confirmation: password) }

      it "connecte avec un OTP valide" do
        post user_session_path, params: {
          user: { email: user.email, password: password, otp_attempt: user.current_otp }
        }
        expect(response).to redirect_to(root_path)
      end

      it "refuse un OTP invalide" do
        post user_session_path, params: {
          user: { email: user.email, password: password, otp_attempt: "000000" }
        }
        expect(response).not_to redirect_to(root_path)
      end

      it "accepte un code de secours" do
        codes = user.generate_otp_backup_codes!
        user.save!
        code = codes.first

        post user_session_path, params: {
          user: { email: user.email, password: password, otp_attempt: code }
        }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
