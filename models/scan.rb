class Scan
  attr_accessor :player, :cell, :time, :accuracy

  def initialize(player, cell, accuracy=nil, time=Time.now)
    @player, @cell, @time, @accuracy= player, cell, time, accuracy
  end
end
