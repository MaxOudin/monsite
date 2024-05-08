# app/services/blob_migration_service.rb
class BlobMigrationService
  def initialize(article)
    @article = article
  end

  def migrate_to_cloud
    return unless should_migrate?
    s3_client = Aws::S3::Client.new(
      access_key_id: ENV.fetch("AWS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_ACCESS_KEY"),
      region: ENV.fetch("AWS_REGION")
    )
    bucket_name = ENV.fetch("AWS_BUCKET")

    @article.content.body.attachments.each do |blob|
      begin
        blob.open(tmpdir: Dir.tmpdir) do |tempfile|
          object_key = "Blob_#{blob.id}_#{blob.filename}"
          s3_client.put_object(bucket: bucket_name, key: object_key, body: tempfile, acl: 'public-read')
          blob.update(service_name: 'amazon', key: object_key)
          puts "Blob #{blob.filename} transferred successfully to S3"
        end
      rescue ActiveStorage::FileNotFoundError
        next
      end
    end
  end

  private

  def should_migrate?
    @article.content.body.attachments.any? && Rails.env.production?
  end

end
