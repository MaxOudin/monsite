# frozen_string_literal: true

require "rails_helper"

RSpec.describe TwoFactorSetupService do
  let(:user) { create(:user) }

  describe "#call" do
    it "génère un secret sans activer le 2FA" do
      expect(described_class.new(user).call).to be true
      user.reload
      expect(user.otp_secret).to be_present
      expect(user.otp_required_for_login).to be false
    end

    it "refuse si le 2FA est déjà activé" do
      user = create(:user, :with_two_factor)
      expect(described_class.new(user).call).to be false
    end
  end
end
