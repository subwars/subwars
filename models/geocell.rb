class Geocell
  CHARACTERS = '0123456789bcdefghjkmnpqrstuvwxyz'.split('').map{|char| char.to_sym}

  attr_reader :parent, :character

  def initialize(character=:' ', parent=nil)
    @character = character
    @parent = parent
  end

  def kids
    @kids ||= Hash.new do |hash,key|
      hash[key] = Geocell.new(key, self) if CHARACTERS.include? key
    end
  end

  def all_kids
    CHARACTERS.each{|char| kids[char]}
    kids
  end

  def [](symbols)
    return self if symbols.nil? || symbols.empty?
    kids[symbols.shift][symbols]
  end

  def geohash
    ((parent.nil? ? '' : parent.geohash) + character.to_s).strip
  end

  def inspect
    '#<%s:%#x @geohash="%s">' % [self.class.name, __id__, geohash]
  end

  def to_hash
    {
      class: self.class.name,
      geohash: geohash,
      contents: contents.map{|c| c.to_hash}
    }
  end

  def contents
    @contents ||= IdentitySet.new
  end

  def add_content(content)
    contents << content
  end

  def remove_content(content)
    contents.delete content
  end
end
