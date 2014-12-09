class Entity
  ROOT_KEY = :ENT
  include Storable

  attr_accessor :name, :game
  attr_accessor :current_cell, :transitions

  def initialize(game, name)
    @game = game
    @name = name
  end

  def root
    game.geocell_root
  end

  def transitions
    @transitions ||= []
  end

  def move_to(cell)
    remove_from_current_cell
    self.current_cell = cell
    cell.add_content self
    transitions << Transition.new(self, cell)
  end

  def remove_from_current_cell
    current_cell.remove_content(self) if current_cell
  end

  def to_hash
    {
      class: self.class.name,
      name: name
    }
  end

  def stage
    super
    move_to root
  end

  def destroy
    super
    remove_from_current_cell
    self.current_cell = nil
  end
end
