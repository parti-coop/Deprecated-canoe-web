class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  cattr_accessor(:skip_slack) { !Rails.env.staging? }

  after_action :allow_iframe

  before_action :prepare_meta_tags, if: "request.get?"

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::AssetUrlHelper

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

  def api?
    false
  end

  private

  def prepare_meta_tags(options={})
    set_meta_tags build_meta_options(options)
  end

  def build_meta_options(options)
    unless options.nil?
      options.compact!
      options.reverse_merge! default_meta_options
    else
      options = default_meta_options
    end

    current_url = request.url
    og_description = (view_context.strip_tags options[:description]).truncate(160)

    {
      site:        options[:site_name],
      title:       options[:title],
      reverse:     true,
      image:       view_context.asset_url(options[:image]),
      description: options[:description],
      keywords:    options[:keywords],
      canonical:   current_url,
      twitter: {
        site_name: options[:site_name],
        site: '@parti_xyz',
        card: 'summary',
        description: twitter_description(options),
        image: view_context.asset_url(options[:image])
      },
      og: {
        url: current_url,
        site_name: options[:site_name],
        title: "#{options[:title]} | #{options[:site_name]}",
        image: view_context.asset_url(options[:image]),
        description: og_description,
        type: 'website'
      }
    }
  end

  def default_meta_options
    {
      site_name: "유쾌한 민주주의 플랫폼, 빠띠",
      title: "카누",
      description: "카누는 일상 민주주의와 민주적인 조직 구조를 실현하려는 그룹을 위한 서비스입니다.",
      keywords: "정치, 민주주의, 조직, 투표, 모임, 의사결정, 일상 민주주의, 토의, 토론, 논쟁, 논의, 회의, 카누",
      image: '/images/parti-canoe.png'
    }
  end

  def twitter_description(options)
    limit = 140
    title = view_context.strip_tags options[:title]
    description = view_context.strip_tags options[:description]
    if title.length > limit
      title.truncate(limit)
    else
      description.truncate(limit)
    end
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end
