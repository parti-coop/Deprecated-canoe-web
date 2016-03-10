class Api::V1::PagesController < Api::V1::BaseController
  def home
    expose({
      canoes: @current_user.joined_canoes,
      tutorials: [
        {
          tutorial_id: "xxx",
          title: "반가워요!<br>유쾌한 민주주의 서비스<br>카누를 시작해보세요.",
          image: {
            url: "img_path"
          },
          url: "link"
        }
      ],
      recommend_canoes: Canoe.order(sailed_at: :desc).limit(10)
     })
  end

  def search_discussions
    query = params[:q]
    @all = (params[:all] || 'false') == 'true'
    if query.present?
      if @all
        @discussions = Discussion.valid_parent.order(discussed_at: :desc).search_for(query)
      else
        @discussions = @current_user.joined_discussions.order(discussed_at: :desc).search_for(query)
      end
      @discussions_on_current_page = @discussions.page(params[:page]).per(5)

      paginated @discussions_on_current_page
    else
      error! :bad_request, 'no params'
    end
  end

  def search_canoes
    query = params[:q]
    if query.present?
      @canoes = Canoe.search_for(query)
      @canoes_on_current_page = @canoes.page(params[:page]).per(5)

      paginated @canoes_on_current_page
    else
      error! :bad_request, 'no params'
    end
  end
end

