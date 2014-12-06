require 'storable'

class Entity
  ROOT_KEY = :entities
  include Storable

  attr_accessor :name
  attr_accessor :current_cell, :transitions

  def self.[](name)
    store.detect{|entity| entity.name == name}
  end

  def initialize(name)
    @name = name
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

  def to_hash
    {
      class: self.class.name,
      name: name
    }
  end

  def remove_from_current_cell
    current_cell.remove_content(self) if current_cell
  end

  def stage
    super
    move_to Geocell.root
  end

  def destroy
    super
    remove_from_current_cell
    self.current_cell = nil
  end
end

Entity.store
