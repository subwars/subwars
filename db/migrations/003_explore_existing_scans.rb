class Migration
  def up
    Player.store.
      map{|p|p.scans.to_a}.flatten.
      map{|scan|scan.cell}.uniq.each do |cell|

      cell.neighbors
    end
  end

  def down
  end
end
