case node[:hostname]
when /\Api-/
  include_recipe 'recipes/pi'
else
  MItamae.logger.warn "Unexpected host: #{node[:hostname]}"
end
