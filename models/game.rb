class Game
  ROOT_KEY = :GAM
  include Storable

  attr_accessor :name, :players, :entities, :geocell_root

  def self.default
    @@default ||= begin
      new_game = self.new 'Default'
      new_game.stage
      new_game
    end
  end

  def initialize(name)
    @name = name
    @players = IdentitySet.new
    @entities = IdentitySet.new
    @geocell_root = GeocellRoot.new name
  end

  def create_player(name)
    players.add Player.new(self, name)
  end

  def to_hash
    {
      class: self.class.name,
      name: name
    }
  end
end

Game.default
