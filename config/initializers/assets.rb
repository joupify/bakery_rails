# config/initializers/assets.rb
Rails.application.config.assets.version = "1.0"

# Ajouter les chemins
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/dist/js")

# ✅ Garder bootstrap.bundle.min.js
Rails.application.config.assets.precompile << "bootstrap.bundle.min.js"

# ✅ Ajouter les fichiers Turbo
Rails.application.config.assets.precompile += %w[
  @hotwired--turbo-rails.js
  @hotwired--turbo.js
]