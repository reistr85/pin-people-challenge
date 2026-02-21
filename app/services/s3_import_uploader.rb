# frozen_string_literal: true

require "aws-sdk-s3"

class S3ImportUploader
  class NotConfiguredError < StandardError; end

  def self.configured?
    bucket.present?
  end

  def self.bucket
    ENV.fetch("S3_IMPORT_BUCKET", nil).presence
  end

  def self.upload(file_path, key: nil)
    raise NotConfiguredError, "S3_IMPORT_BUCKET não configurado" unless configured?

    key ||= "imports/#{Time.current.strftime('%Y/%m/%d')}/#{SecureRandom.uuid}.csv"
    object = s3_client.bucket(bucket).object(key)
    object.upload_file(file_path, content_type: "text/csv")
    { bucket: bucket, key: key }
  end

  def self.download(bucket_name, key)
    object = s3_client.bucket(bucket_name).object(key)
    object.get.body.read
  end

  def self.s3_client
    opts = { region: ENV.fetch("AWS_REGION", "us-east-1") }
    if ENV["AWS_ACCESS_KEY_ID"].present?
      opts[:access_key_id] = ENV["AWS_ACCESS_KEY_ID"]
      opts[:secret_access_key] = ENV["AWS_SECRET_ACCESS_KEY"]
    end
    @s3_client ||= Aws::S3::Resource.new(**opts)
  end
end
