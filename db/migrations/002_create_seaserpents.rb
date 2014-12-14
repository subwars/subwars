class Migration
  def up
    Player.store.
      map{|p|p.scans.to_a}.flatten.each do |scan|

      # 1% chance per scan of spawning a seaserpent
      if rand > 0.99
        ss = Seaserpent.create(scan.player.game)
        ss.move_to scan.cell
        p scan.cell.geohash
      end
    end
  end

  def down
    Entity.store.select{|e|e.kind_of? Seaserpent}.each do |ss|
      p [ss.current_cell.geohash]
      ss.current_cell.contents.delete ss
      ss.destroy
    end
  end
end
