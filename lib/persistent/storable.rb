module Storable
  def self.included(base)
    base.extend ClassMethods
    base.store
    base.attr_reader :uuid
  end

  module ClassMethods
    def root_key
      self::ROOT_KEY
    end

    def size
      store.size
    end

    def store
      Maglev[root_key] ||= IdentitySet.new
    end

    def [](uuid)
      store.detect{|o| o.uuid == uuid}
    end

    def new_uuid
      '%s-%s' % [ root_key.to_s.upcase, `uuidgen`.chomp.upcase ]
    end
  end

  def new_uuid!
    @uuid = self.class.new_uuid if uuid.nil?
  end

  def stage
    new_uuid!
    self.class.store.add self
  end

  def destroy
    self.class.store.delete self
  end
end
