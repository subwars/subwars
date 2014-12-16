class GeocellRoot
  ROOT_KEY = :GCR
  include Storable

  attr_reader :name, :cell

  def initialize(name)
    @name = name
    @cell = Geocell.new
  end

  def [](hash_string)
    symbols = hash_string.split('').map{|char| char.to_sym}
    cell[symbols]
  end

  def leaves
    cell.descendants(true)
  end

  def to_hash
    {
      class: self.class.name,
      name: name,
      cell: cell.to_hash
    }
  end
end
