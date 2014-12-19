module GeocellNeighborhood
  CHARACTERS = '0123456789bcdefghjkmnpqrstuvwxyz'.split('').map{|char| char.to_sym}

  NEIGHBOR_CHARS = %w[
    bc01fg45238967deuvhjyznpkmstqrwx
    p0r21436x8zb9dcf5h7kjnmqesgutwvy
    238967debc01fg45kmstqrwxuvhjyznp
    14365h7k9dcfesgujnmqp0r2twvyx8zb
  ].map{|arr| arr.split('').map{|char| char.to_sym}}

  NEIGHBORS = {
    :right  => { :even => NEIGHBOR_CHARS[0], :odd => NEIGHBOR_CHARS[1] },
    :left   => { :even => NEIGHBOR_CHARS[2], :odd => NEIGHBOR_CHARS[3] },
    :top    => { :even => NEIGHBOR_CHARS[1], :odd => NEIGHBOR_CHARS[0] },
    :bottom => { :even => NEIGHBOR_CHARS[3], :odd => NEIGHBOR_CHARS[2] }
  }

  BORDER_CHARS = %w[
    bcfguvyz prxz 0145hjnp 028b
  ].map{|arr| arr.split('').map{|char| char.to_sym}}

  BORDERS = {
    :right  => { :even => BORDER_CHARS[0], :odd => BORDER_CHARS[1] },
    :left   => { :even => BORDER_CHARS[2], :odd => BORDER_CHARS[3] },
    :top    => { :even => BORDER_CHARS[1], :odd => BORDER_CHARS[0] },
    :bottom => { :even => BORDER_CHARS[3], :odd => BORDER_CHARS[2] }
  }

  def border?(direction)
    BORDERS[direction][even_odd].include?(character)
  end

  def neighbor_char(direction)
    CHARACTERS[NEIGHBORS[direction][even_odd].index(character)]
  end

  def even_odd
    (geohash.length % 2).zero? ? :even : :odd
  end

  def neighbor(direction)
    new_parent = border?(direction) ?
      parent.neighbor(direction) : parent
    new_parent[Array(neighbor_char(direction))]
  end

  def neighbors(depth=1)
    cells = [
      neighbor(:right), neighbor(:left), neighbor(:top), neighbor(:bottom),
      neighbor(:right).neighbor(:bottom), neighbor(:left).neighbor(:top),
      neighbor(:top).neighbor(:right), neighbor(:bottom).neighbor(:left)
    ]
    (depth-1).times do
      cells = cells.map{|c| c.neighbors.to_a}.flatten
    end
    IdentitySet.with_all cells
  end
end
