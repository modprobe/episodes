require 'sinatra'
require 'haml'
require './tvrage.rb'

get '/' do
  haml :search
end

get '/random/:sid' do
  show = TVRage::Show.new(params[:sid])
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
  show = TVRage::Show.new(params[:sid])
  ep = show.random_episode
  { title: ep.title, episode_no: "#{ep.season}&times;#{ep.episode_number}" }.to_json
end
