# frozen_string_literal: true

require "rails_helper"

RSpec.describe TwoFactorConfirmService do
  let(:user) { create(:user) }

  before do
    TwoFactorSetupService.new(user).call
    user.reload
  end

  describe "#call" do
    it "active le 2FA et renvoie des codes de secours" do
      result = described_class.new(user, otp_attempt: user.current_otp).call

      expect(result.success?).to be true
      expect(result.backup_codes).to be_present
      expect(user.reload.otp_required_for_login).to be true
    end

    it "refuse un OTP invalide" do
      result = described_class.new(user, otp_attempt: "000000").call

      expect(result.success?).to be false
      expect(result.error).to eq(:invalid_otp)
      expect(user.reload.otp_required_for_login).to be false
    end
  end
end
