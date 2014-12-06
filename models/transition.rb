class Transition
  attr_accessor :entity, :cell, :time

  def initialize(entity, cell, time=Time.now)
    @entity, @cell, @time = entity, cell, time
  end
end
