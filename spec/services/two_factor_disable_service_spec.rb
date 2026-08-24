# frozen_string_literal: true

require "rails_helper"

RSpec.describe TwoFactorDisableService do
  let(:password) { "motdepasse-test-123" }
  let(:user) { create(:user, :with_two_factor, password: password, password_confirmation: password) }

  describe "#call" do
    it "désactive le 2FA avec mot de passe et OTP valides" do
      result = described_class.new(user, password: password, otp_attempt: user.current_otp).call

      expect(result.success?).to be true
      user.reload
      expect(user.otp_required_for_login).to be false
      expect(user.otp_secret).to be_nil
    end

    it "refuse un mot de passe invalide" do
      result = described_class.new(user, password: "mauvais-mot-de-passe", otp_attempt: user.current_otp).call

      expect(result.success?).to be false
      expect(result.error).to eq(:invalid_password)
    end
  end
end
