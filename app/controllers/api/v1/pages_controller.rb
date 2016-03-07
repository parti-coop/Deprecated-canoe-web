class Api::V1::PagesController < Api::V1::BaseController
  def home
    expose({
      canoes: @current_user.joined_canoes,
      tutorials: [
        {
          tutorial_id: "xxx",
          title: "반가워요!<br>유쾌한 민주주의 서비스<br>카누를 시작해보세요.",
          image: "img_path",
          link: "link"
        }
      ],
      recommend_canoes: Canoe.order(sailed_at: :desc).limit(10)
     })
  end
end

