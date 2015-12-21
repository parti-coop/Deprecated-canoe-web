Rails.application.config.to_prepare do
  User.class_eval do
    has_many :crews
    has_many :canoes
    has_many :crewing_canoes, class_name: Canoe, through: :crews, source: :canoe
  end
end
