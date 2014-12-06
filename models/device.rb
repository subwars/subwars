class Device < Entity
  attr_accessor :player

  def self.class_for_type(type)
    Object.const_get '%sDevice' % type.to_s.capitalize
  end

  def self.new_for_type(type, player)
    class_for_type(type).new(player)
  end

  def initialize(player)
    super '%s:%s' % [player.name, self.class.name]
    @player = player
  end

  def to_hash
    super.merge type: type
  end

  def type
    self.class.type
  end

  def is_type?(device_type)
    device_type.to_sym == type
  end
end

class MobileDevice < Device
  def self.type; :mobile; end
end
class TabletDevice < Device
  def self.type; :tablet; end
end
class DesktopDevice < Device
  def self.type; :desktop; end
end
