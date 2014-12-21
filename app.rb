require 'rubygems'
require 'bundler'
Bundler.require

require './helpers'

module Subwars
  class App < Sinatra::Application
    include Subwars::Helpers

    configure do
      set :root, App.root
      enable :static
      set :sessions, secret: ENV['SESSION_SECRET'] || 'subs'
    end

    before{ Maglev.abort }

    get '/' do
      send_file File.expand_path('../public/index.html', __FILE__)
    end

    post '/move' do
      current_player.current_ship.move_to geocell_param
      Maglev.commit
      status 204
    end

    get '/map' do
      content_type :json

      parent = geocell_param.geohash.length.zero? ?
        geocell_param.kids.values.first :
        geocell_param.parent

      siblings_and_cousins = parent.neighbors(2).inject(IdentitySet.with_all(parent.all_kids.values)) do |set, neighbor|
        neighbor.all_kids.values.each{|cousin| set.add cousin}
        set
      end

      icons = siblings_and_cousins.inject([]) do |arr,cell|
        background_class = 'ocean' # current_player.scans.any?{|scan| scan.cell == cell} ? 'ocean' : 'ocean-gray'
        icon_classes = cell.contents.map do |entity|
          '%s-%s' % [entity.icon, (current_player.current_ship == entity ? 'self' : 'normal')]
        end
        arr << [cell.geohash, background_class, icon_classes]
        arr
      end

      JSON.dump icons
    end

    post '/scans' do
      current_player.scan geocell_param, params[:accuracy].to_f
      geocell_param.neighbors(2).each do |cell|
        if rand > 0.999
          ss = Seaserpent.create(game)
          ss.move_to cell
        end
      end
      #current_player.current_ship.move_to geocell_param
      Maglev.commit
      status 204
    end

    get '/signin/:name' do
      player_name = params[:name]
      player = Player.find_by_name(player_name) || create_player(player_name)
      signin_as(player)
      redirect '/'
    end

    get '/signout' do
      session.destroy
      redirect '/'
    end
  end
end
