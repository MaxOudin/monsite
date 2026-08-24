# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Two factor settings", type: :request do
  let(:password) { "motdepasse-test-123" }
  let(:user) { create(:user, password: password, password_confirmation: password) }

  before { sign_in user }

  describe "POST /compte/2fa" do
    it "prépare un secret sans activer le 2FA" do
      post two_factor_settings_path
      expect(response).to redirect_to(two_factor_settings_path)
      expect(user.reload.otp_secret).to be_present
      expect(user.otp_required_for_login).to be false
    end
  end

  describe "POST /compte/2fa/confirm" do
    before do
      TwoFactorSetupService.new(user).call
      user.reload
    end

    it "active le 2FA et redirige vers les codes de secours" do
      post confirm_two_factor_settings_path, params: { otp_attempt: user.current_otp }
      expect(response).to redirect_to(backup_codes_two_factor_settings_path)
      expect(user.reload.otp_required_for_login).to be true
    end
  end
end
