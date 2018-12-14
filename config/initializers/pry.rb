Pry.config.prompt_name = :robin
color = Rails.env.production? ? :red : :cyan
prefix = Pry::Helpers::Text.public_send(color, Rails.env.upcase)

Pry.config.prompt = [
  proc { |*args| "#{prefix} #{Pry::Prompt[:default][:value].first.call(*args)}" },
  proc { |*args| "#{prefix} #{Pry::Prompt[:default][:value].second.call(*args)}" },
]
