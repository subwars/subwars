module Subwars
  module Helpers
    def current_device
      current_player.device_by_type(device_type) ||
        current_player.add_device(device_type)
    end

    def device_type
      request.env['mobvious.device_type'] || :unknown
    end

    def geohash_precision
      8
    end

    def geohash_param
      (params[:geohash] || '')[0...geohash_precision]
    end

    def geocell_param
      Geocell[geohash_param]
    end

    def create_player(player_name)
      player = Player.new player_name
      player.add_device device_type
      player.stage
      Maglev.commit
      player
    end

    def current_player
      if session[:player_id] && (player = ObjectSpace._id2ref session[:player_id])
        return player
      else
        player = create_player('Unknown')
        signin_as(player)
        player
      end
    end

    def signin_as(player)
      session[:player_id] = player.__id__
    end
  end
end
