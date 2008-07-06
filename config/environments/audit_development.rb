# Settings specified here will take precedence over those in config/environment.rb

# Set class caching to true, so that acts_as_audited can work
config.cache_classes = true

# Leave the rest of the file as development mode defaults.

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false