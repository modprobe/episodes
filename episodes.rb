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
