if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => ENV['ap-northeast-1'],
      :aws_access_key_id     => ENV['AKIA33ICMT73Y4M735WW'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['picturebk']
  end
end