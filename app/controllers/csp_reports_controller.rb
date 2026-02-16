class CspReportsController < ApplicationController
    def create
        report = request.body.read
        parsed_report = JSON.parse(report) rescue {}
        
        # Log détaillé pour debug
        Rails.logger.info("=" * 50)
        Rails.logger.info("CSP VIOLATION DETECTED")
        Rails.logger.info("=" * 50)
        Rails.logger.info("Full report: #{report}")
        
        if parsed_report['csp-report']
          csp_report = parsed_report['csp-report']
          Rails.logger.info("Document URI: #{csp_report['document-uri']}")
          Rails.logger.info("Violated directive: #{csp_report['violated-directive']}")
          Rails.logger.info("Blocked URI: #{csp_report['blocked-uri']}")
          Rails.logger.info("Source file: #{csp_report['source-file']}")
          Rails.logger.info("Line number: #{csp_report['line-number']}")
          Rails.logger.info("Script sample: #{csp_report['script-sample']}")
        end
        
        Rails.logger.info("=" * 50)
        
        head :no_content
    end
end
