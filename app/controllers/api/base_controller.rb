class Api::BaseController < RocketPants::Base

  map_error! ActiveRecord::RecordNotFound, RocketPants::NotFound

  # For the api to always revalidate on expiry.
  caching_options[:must_revalidate] = true
end
