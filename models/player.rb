class Player
  ROOT_KEY = :PLA
  include Storable

  attr_accessor :game, :name, :scans

  def self.find_by_name(name)
    store.detect{|entity| entity.name == name}
  end

  def initialize(game, name)
    @game, @name = game, name
    @scans = IdentitySet.new
  end

  def scan(geocell, time=Time.now)
    scans << Scan.new(self, geocell, time)
  end

  def to_hash
    {
      class: self.class.name,
      name: name
    }
  end
end
