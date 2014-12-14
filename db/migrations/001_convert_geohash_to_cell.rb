class Migration
  def up
    Player.store.
      map{|p|p.scans.to_a}.flatten.
      select{|scan| scan.cell.kind_of? String}.each do |scan|

      geohash = scan.cell
      scan.cell = scan.player.root[geohash]
    end
  end

  def down
    Player.store.
      map{|p|p.scans.to_a}.flatten.
      reject{|scan| scan.cell.kind_of? String}.each do |scan|

      scan.cell = scan.cell.geohash
    end
  end
end
