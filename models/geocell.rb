class Geocell
  ROOT_KEY = :geocell_root

  CHARACTERS = '0123456789bcdefghjkmnpqrstuvwxyz'.split('').map{|char| char.to_sym}
  COORDINATES = [
    [0,0], [1,0], [0,1], [1,1], [2,0], [3,0], [2,1], [3,1],
    [0,2], [1,2], [0,3], [1,3], [2,2], [3,2], [2,3], [3,3],
    [4,0], [5,0], [4,1], [5,1], [6,0], [7,0], [6,1], [7,1],
    [4,2], [5,2], [4,3], [5,3], [6,2], [7,2], [6,3], [7,3]
  ]

  attr_reader :parent, :character

  def self.initialize_store
    Maglev[ROOT_KEY] ||= self.new
    nil
  end

  def self.root
    Maglev[ROOT_KEY]
  end

  def self.[](hash_string)
    symbols = hash_string.split('').map{|char| char.to_sym}
    root[symbols]
  end

  def initialize(character=:' ', parent=nil)
    @character = character
    @parent = parent
  end

  def coordinate
    COORDINATES[CHARACTERS.index(character) || 0]
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

Geocell.initialize_store
