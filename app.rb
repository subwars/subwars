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

    get '/geocells/:geohash' do
      content_type :json
      JSON.dump geocell_param.to_hash
    end

    get '/map' do
      content_type :json
      cells = current_player.game.geocell_root.leaves.select{|c|c.geohash.length == 8}
      arrays = cells.map do |cell|
        icons = cell.contents.map{|e|e.icon}
        [cell.geohash, icons]
      end
      JSON.dump arrays
    end

    get '/scans' do
      content_type :json
      cells = current_player.scans.map{|scan| scan.cell}.uniq
      arrays = cells.map do |cell|
        icons = cell.contents.map{|e|e.icon}
        [cell.geohash, icons]
      end
      JSON.dump arrays
    end

    post '/scans' do
      geocell = current_player.root[geohash_param]
      current_player.scan geocell, params[:accuracy].to_f
      current_player.current_ship.move_to geocell
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
