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

get '/api/autocomplete' do
  logger.info "Searching for #{params[:term]}"
  res = TVRage::Search.new(params[:term]).execute
  haml :results, 'locals': { 'res': res }
end

get '/api/random/:sid' do
  content_type :json
  show = TVRage::Show.new(params[:sid])
  ep = show.random_episode
  { title: ep.title, episode_no: "#{ep.season}&times;#{ep.episode_number}" }.to_json
end
