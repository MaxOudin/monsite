require 'rails_helper'

RSpec.describe "CspReports", type: :request do
  describe "POST /csp-violation-report-endpoint" do
    it "répond 204 No Content pour un rapport CSP valide" do
      report = { "csp-report" => { "document-uri" => "https://example.com",
                                   "violated-directive" => "script-src" } }
      post csp_violation_report_endpoint_path,
           params: report.to_json,
           headers: { "Content-Type" => "application/csp-report" }

      expect(response).to have_http_status(:no_content)
    end

    it "ne plante pas sur un corps non-JSON" do
      post csp_violation_report_endpoint_path,
           params: "ceci n'est pas du json",
           headers: { "Content-Type" => "text/plain" }

      expect(response).to have_http_status(:no_content)
    end
  end
end
