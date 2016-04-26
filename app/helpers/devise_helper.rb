module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?
    raw render(partial: 'devise/shared/error_messages', resource: resource)
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end
end
