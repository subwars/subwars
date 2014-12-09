class Scan
  attr_accessor :player, :cell, :time

  def initialize(player, cell, time=Time.now)
    @player, @cell, @time = player, cell, time
  end
end
