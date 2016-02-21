class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  cattr_accessor(:skip_slack) { !Rails.env.staging? }

  include PartiSsoClient::Authentication
  before_action :verify_authentication
  after_action :allow_iframe

  before_action :prepare_meta_tags, if: "request.get?"

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::AssetUrlHelper

  def prepare_meta_tags(options={})
    site_name   = "카누 | parti.xyz"
    title       = "함께 결정하는 작은 배"
    description = "카누는 일상 민주주의와 민주적인 조직 구조를 실현하려는 그룹을 위한 서비스입니다."
    keywords    = "정치, 민주주의, 조직, 투표, 모임, 의사결정, 일상 민주주의, 토의, 토론, 논쟁, 논의, 회의, 카누"
    image       = image_url(options[:image] || "parti-canoe.png")
    current_url = request.url

    defaults = {
      site:        site_name,
      title:       title,
      reverse:     true,
      image:       image_url(image),
      description: :description,
      keywords:    keywords,
      twitter: {
        site_name: title,
        site: '@parti_xyz',
        card: 'summary',
        description: :description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: :description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    logger.debug "meta: #{options.inspect}"

    set_meta_tags options
  end

  def redirect_to(*args)
    if args[0].class == Canoe and args[0].try(:persisted?)
      super short_canoe_path(args[0].slug), *args[1..-1]
    elsif args[0].class == Discussion and args[0].try(:persisted?) and args[0].canoe.try(:persisted?)
      super short_discussion_path(args[0].canoe.slug, args[0].sequential_id), *args[1..-1]
    else
      super *args
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end
