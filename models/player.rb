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

  def root
    game.geocell_root
  end

  def fleet
    @fleet ||= IdentitySet.new
  end

  def current_ship
    fleet.to_a.first || create_ship
  end

  def create_ship
    fleet << Submarine.create(game)
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

  def inspect
    '#<Player:%#x @name="%s" @uuid="%s" num_scans=%i>' %
      [ object_id, name, uuid, scans.size ]
  end
end
