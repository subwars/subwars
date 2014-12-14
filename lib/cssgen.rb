# b c f g u v y z
# 8 9 d e s t w x
# 2 3 6 7 k m q r
# 0 1 4 5 h j n p

# p r x z
# n q w y
# j m t v
# h k s u
# 5 7 e g
# 4 6 d f
# 1 3 9 c
# 0 2 8 b

class Cell
  CHARACTERS = '0123456789bcdefghjkmnpqrstuvwxyz'.split('')

  COORDINATES = {
    :vertical => {
      'p'=>[0,0], 'r'=>[1,0], 'x'=>[2,0], 'z'=>[3,0],
      'n'=>[0,1], 'q'=>[1,1], 'w'=>[2,1], 'y'=>[3,1],
      'j'=>[0,2], 'm'=>[1,2], 't'=>[2,2], 'v'=>[3,2],
      'h'=>[0,3], 'k'=>[1,3], 's'=>[2,3], 'u'=>[3,3],
      '5'=>[0,4], '7'=>[1,4], 'e'=>[2,4], 'g'=>[3,4],
      '4'=>[0,5], '6'=>[1,5], 'd'=>[2,5], 'f'=>[3,5],
      '1'=>[0,6], '3'=>[1,6], '9'=>[2,6], 'c'=>[3,6],
      '0'=>[0,7], '2'=>[1,7], '8'=>[2,7], 'b'=>[3,7]
    },
    :horizontal => {
      'b'=>[0,0], 'c'=>[1,0], 'f'=>[2,0], 'g'=>[3,0],
      'u'=>[4,0], 'v'=>[5,0], 'y'=>[6,0], 'z'=>[7,0],
      '8'=>[0,1], '9'=>[1,1], 'd'=>[2,1], 'e'=>[3,1],
      's'=>[4,1], 't'=>[5,1], 'w'=>[6,1], 'x'=>[7,1],
      '2'=>[0,2], '3'=>[1,2], '6'=>[2,2], '7'=>[3,2],
      'k'=>[4,2], 'm'=>[5,2], 'q'=>[6,2], 'r'=>[7,2],
      '0'=>[0,3], '1'=>[1,3], '4'=>[2,3], '5'=>[3,3],
      'h'=>[4,3], 'j'=>[5,3], 'n'=>[6,3], 'p'=>[7,3]
    }
  }

  def self.generate
    #CHARACTERS.each do |c|
    #  cell = new(c, 16384, false)
    #  str = "\#grid .gh-#{c}--- #{cell.string}"
    #  puts str
    #end
    CHARACTERS.each do |c|
      cell = new(c, 2048, false)
      str = "\#grid .gh-#{c}--- #{cell.string}"
      puts str
    end
    CHARACTERS.each do |c|
      cell = new(c, 512)
      str = "\#grid  .gh-#{c}-- #{cell.string}"
      puts str
    end
    CHARACTERS.each do |c|
      cell = new(c, 64, false)
      str = "\#grid   .gh-#{c}- #{cell.string}"
      puts str
    end
    CHARACTERS.each do |c|
      cell = new(c)
      str = "\#grid    .gh-#{c} #{cell.string}"
      puts str
    end
  end

  def self.generate_32
    CHARACTERS.each do |c|
      cell = new(c, 4096, false)
      str = "\#grid .gh-#{c}--- #{cell.string}"
      puts str
    end
    CHARACTERS.each do |c|
      cell = new(c, 1024)
      str = "\#grid  .gh-#{c}-- #{cell.string}"
      puts str
    end
    CHARACTERS.each do |c|
      cell = new(c, 128, false)
      str = "\#grid   .gh-#{c}- #{cell.string}"
      puts str
    end
    CHARACTERS.each do |c|
      cell = new(c, 32)
      str = "\#grid    .gh-#{c} #{cell.string}"
      puts str
    end
  end

  def string
    args = extent + position
    '{ width: %4ipx; height: %4ipx; left: %5ipx; top: %5ipx; }' % args
  end

  #def initialize(character, opts={})
  #  @character = character
  #  @vertical = !!opts[:vertical]
  #  @precision = opts[:precision] || 1
  #end

  def initialize(character, pixels=16, vertical=true)
    @character = character
    @pixels = pixels
    @vertical = vertical
  end

  # size of cell - bottom right corner
  def extent
    size.map{|i| i * @pixels}
  end

  def coord
    COORDINATES.fetch(direction)[@character]
  end

  def position
    [coord.first * size.first * @pixels,
     coord.last * size.last * @pixels]
  end

  #def base_pixel_size
  #  16
  #end

  #def pixels
  #  @scale * base_pixel_size
  #end

  def height
    @vertical ? 7 : 3
  end

  def size
    @vertical ? [1,1] : [1,2]
  end

  #def coord
  #  @vertical ? COORDS[@character] : COORDS[@character].reverse
  #end

  #def raw_position
  #  [coord.first * cell_extent.first, coord.last * cell_extent.last]
  #end

  #def position_string(character, opts={})
  #  opts = {vertical:true, precision:1}.merge(opts)

  #  height = opts[:vertical] ? 7 : 3
  #  precision = opts[:precision].to_i

  #  cell_extent = [precision * 32, precision * 64]

  #  coord = coordinate(character)

  #  p [coord, cell_extent]

  #  if opts[:vertical]
  #    coord.reverse!
  #    cell_extent.reverse!
  #  end

  #  p [coord, cell_extent]

  #  coord = [coord.first, height-coord.last]
  #  p [coord, cell_extent]
  #  positions = [coord.first * cell_extent.first, coord.last * cell_extent.last]

  #  p [coord, cell_extent, positions]
  #  '{ left: %4ipx; top: %4ipx; }' % positions
  #end

  def direction
    @vertical ? :vertical : :horizontal
  end
end
