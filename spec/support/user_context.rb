shared_context 'user' do

  def users_exist(attrs_set)
    attrs_set.map do |attrs|
      FactoryGirl.create(:user, attrs)
    end
  end

end
