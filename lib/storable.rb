module Storable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def root_key
      self::ROOT_KEY
    end

    def store
      Maglev[root_key] ||= IdentitySet.new
    end
  end

  def stage
    self.class.store.add self
  end

  def destroy
    self.class.store.delete self
  end
end
