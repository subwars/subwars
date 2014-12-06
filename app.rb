require 'rubygems'
require 'bundler'
Bundler.require

require './helpers'

module Subwars
  class App < Sinatra::Application
    include Subwars::Helpers

    configure do
      Mobvious.configure do |config|
        config.strategies = [ Mobvious::Strategies::MobileESP.new ]
      end
      use Mobvious::Manager
      set :root, App.root
      enable :static
      set :sessions, secret: ENV['SESSION_SECRET'] || 'subs'
    end

    before do
      Maglev.abort
    end

    get '/' do
      send_file File.expand_path('../public/index.html', __FILE__)
    end

    get '/geocells/:geohash' do
      content_type :json
      JSON.dump geocell_param.to_hash
    end

    get '/ping/:geohash' do
      content_type :json
      current_device.move_to geocell_param
      Maglev.commit

      'Pinged as %s in %s' % [current_device.name, geohash_param]
    end

    get '/signin/:name' do
      player_name = params[:name]
      player = Player[player_name] || create_player(player_name)
      signin_as(player)

      'Signed in as %s:%#x' % [player_name, session[:player_id]]
    end

    get '/signout' do
      session.destroy

      'Signed out'
    end

    get '/device' do
      content_type :json
      JSON.dump current_device.to_hash
    end
  end
end
