Canoe.class_eval do

  @last_created = nil

  after_create do
    self.class.set_last_created self
  end

  def self.set_last_created(obj)
    @last_created = obj
  end

  def self.last_created
    @last_created
  end

end
