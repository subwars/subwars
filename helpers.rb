module Subwars
  module Helpers
    def geohash_precision
      8
    end

    def geohash_param
      (params[:geohash] || '')[0...geohash_precision]
    end

    def game
      Game.default
    end

    def geocell_param
      game.geocell_root[geohash_param]
    end

    def create_player(player_name)
      player = game.create_player player_name
      player.stage
      Maglev.commit
      player
    end

    def current_player
      if session[:player_uuid] && (player = Player[session[:player_uuid]])
        return player
      else
        player = create_player('Unknown')
        signin_as(player)
        player
      end
    end

    def signin_as(player)
      session[:player_id] = player.uuid
    end
  end
end
