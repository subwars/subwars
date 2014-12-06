require 'storable'

class Player
  ROOT_KEY = :players
  include Storable

  attr_accessor :devices, :name

  def self.[](name)
    store.detect{|entity| entity.name == name}
  end

  def initialize(name)
    @name = name
    @devices = IdentitySet.new
  end

  def device_by_type(device_type)
    dbt = devices.detect{|d| d.is_type? device_type}
    dbt
  end

  def add_device(device_type)
    if (current_device = device_by_type(device_type))
      return current_device
    end

    new_device = Device.new_for_type(device_type, self)
    devices << new_device
  end

  def to_hash
    {
      class: self.class.name,
      name: name
    }
  end
end

Player.store
