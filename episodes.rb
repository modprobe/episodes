require 'sinatra'
require 'haml'
require './tvrage.rb'
require 'redis'

get '/' do
  haml :search
end

def load_or_create_show sid
  redis = Redis.new
  if redis.exists sid
    show = TVRage::Show.deserialise redis.get sid
  else
    show = TVRage::Show.new(sid)
    show.fetch_episodes
    redis.set show.sid, show.serialise, {ex: 7200}
  end

  show
end

get '/random/:sid' do
  show = load_or_create_show params[:sid]
  ep = show.random_episode
  haml :random, 'locals': { 'show': show, 'episode': ep }
end

get '/api/autocomplete/json' do
  content_type :json
  res = TVRage::Search.new(params[:term]).execute
  returnme = []
  res[0..10].each do |sh|
    returnme << { label: "#{sh.name} (#{sh.startyear}-#{sh.endyear})", link: "/random/#{sh.sid}", value: sh.name }
  end
  returnme.to_json
end

get '/api/random/:sid/json' do
  content_type :json
  show = load_or_create_show params[:sid]
  ep = show.random_episode
  { title: ep.title, episode_no: "#{ep.season}&times;#{ep.episode_number}" }.to_json
end
