# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( jquery.min.js )
Rails.application.config.assets.precompile += %w( d3.min.js )
Rails.application.config.assets.precompile += %w( makemap.js )
Rails.application.config.assets.precompile += %w( points.js )
Rails.application.config.assets.precompile += %w( queue.min.js )
Rails.application.config.assets.precompile += %w( topojson.min.js )
Rails.application.config.assets.precompile += %w( tests.js )
Rails.application.config.assets.precompile += %w( qunit-1.19.0.js)
Rails.application.config.assets.precompile += %w( us.json.js )

Rails.application.config.assets.precompile += %w( indexstyle.css )
Rails.application.config.assets.precompile += %w( mapstyle.css )
Rails.application.config.assets.precompile += %w( qunit-1.19.0.css)