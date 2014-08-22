# Added to your config\initializers file
Infusionsoft.configure do |config|
  config.api_url = 'ja203.infusionsoft.com' # example infused.infusionsoft.com
  config.api_key = 'b2c67dce03805b29bb2247396035ab5b'
  config.api_logger = Logger.new("#{Rails.root}/log/infusionsoft_api.log") # optional logger file
end