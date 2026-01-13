RubyLLM.configure do |config|
  # Gemini API key (free tier)

  # Use Gemini free tier model as default
  # config.default_model = "gemini-2.5-flash"
  
  # local config
  config.openai_api_base = 'http://localhost:4141/v1'
  config.default_model = "gpt-5"
  config.openai_api_key = 'local-dev-key'

  # config.gemini_api_key = ENV["GEMINI_API_KEY"] || Rails.application.credentials.dig(:gemini_api_key)


  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true

  # Logging configuration
  config.log_file = Rails.root.join("log/ruby_llm.log") if Rails.env.development?
  config.log_level = Rails.env.production? ? :warn : :debug
end
