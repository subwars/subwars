class Game
  ROOT_KEY = :GAM
  include Storable

  attr_accessor :name, :players, :entities

  def self.default
    @@default ||= create 'Default'
  end

  def initialize(name='unknown')
    @name = name
    @players = IdentitySet.new
    @entities = IdentitySet.new
  end

  def geocell_root
    @geocell_root ||= GeocellRoot.create name
  end

  def create_player(name)
    players.add Player.create(self, name)
  end

  def to_hash
    {
      class: self.class.name,
      name: name
    }
  end
end

Game.default
