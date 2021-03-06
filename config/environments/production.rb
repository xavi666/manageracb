Manageracb::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.teams = {
                  "BALONCESTO SEVILLA" => 1,
                  "CAI ZARAGOZA" => 2, 
                  "DOMINION BILBAO BASKET" => 3, 
                  "FIATC JOVENTUT" => 4, 
                  "FC BARCELONA LASSA" => 5, 
                  "HERBALIFE GRAN CANARIA" => 6, 
                  "ICL MANRESA" => 7, 
                  "IBEROSTAR TENERIFE" => 8, 
                  "LABORAL KUTXA BASKONIA" => 9, 
                  "MONTAKIT FUENLABRADA" => 10, 
                  "MORABANC ANDORRA" => 11,
                  "MOVISTAR ESTUDIANTES" => 12, 
                  "UCAM MURCIA" => 13, 
                  "UNICAJA" => 14, 
                  "REAL MADRID" => 15,
                  "RETABET.ES GBC" => 16, 
                  "RIO NATURA MONBUS OBRADOIRO" => 17, 
                  "VALENCIA BASKET CLUB" => 18,
                  "UCAM MURCIA CB" => 13,
                  "GIPUZKOA BASKET" => 16,
                  "LA BRUIXA D'OR MANRESA" => 7,
                  "FC BARCELONA" => 5,
                  "DOMINION BILBAO" => 3,
                  "TUENTI MóVIL ESTUDIANTES" => 12,
                  "TUENTI M&#xF3;VIL ESTUDIANTES" => 12,
                  "BILBAO BASKET" => 3,
                  "DOMINION BILBAO BASKET" => 3,
                  "FC BARCELONA LASSA" => 5,
                  "ICL MANRESA" => 7,
                  "RIO NATURA MONBUS OBR." => 17
                }

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :info

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end
