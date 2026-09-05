# Be sure to restart your server when you modify this file.

# Version of your assets
Rails.application.config.assets.version = "1.0"

# Asset paths
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/dist/js")

# Precompile Bootstrap
Rails.application.config.assets.precompile += %w[
  bootstrap.bundle.min.js
]