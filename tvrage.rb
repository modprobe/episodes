require 'restclient'
require 'nokogiri'
require 'date'

module TVRage
  API_URL = 'http://services.tvrage.com/feeds'

  #class JSONable
    #def to_json
      #hash = {}
      #self.instance_variables.each do |var|
        #hash[var] = self.instance_variable_get var
      #end
      #hash.to_json
    #end
    #def from_json! string
      #JSON.load(string).each do |var, val|
        #self.instance_variable_set var, val
      #end
    #end
  #end

  class Episode
    attr_accessor :season, :episode_number, :title, :airdate

    def initialize(season, epno, title, airdate)
      @season = season
      @episode_number = epno
      @title = title
      if airdate.instance_of? String
        begin
          @airdate = Date.parse(airdate)
        rescue ArgumentError
          @airdate = nil
        end
      elsif airdate.instance_of? Date
        @airdate = airdate
      end
    end

    def serialise(options = {json: false})
      hash = {}
      self.instance_variables.each do |var|
        hash[var] = self.instance_variable_get var
      end
      if options[:json]
        hash.to_json
      else
        hash
      end
    end

    def self.deserialise input
      hash = if input.instance_of? Hash then input elsif input.instance_of? String then JSON.parse input end
      temp_obj = Episode.new(nil, nil, nil, nil)
      hash.each do |key, val|
        if key == "@airdate"
          begin
            temp_obj.instance_variable_set key, Date.parse(val)
          rescue
            temp_obj.instance_variable_set key, nil
          end
        else
          temp_obj.instance_variable_set key, val
        end
      end

      temp_obj
    end

    def to_s
      "#{@season}x#{@episode_number} - #{@title}"
    end
  end

  class Show
    attr_accessor :sid, :name, :startyear, :endyear, :episodelist

    # TODO: get episode list only when needed

    def initialize(sid, name = nil, startyear = nil, endyear = nil)
      @sid = sid unless sid.nil?
      if !sid.nil? && name.nil? && startyear.nil? && endyear.nil?
        show_info = get_show_info
        @name = show_info[:name]
        @startyear = show_info[:started]
        @endyear = show_info[:ended]
      else
        @name = name
        @startyear = startyear
        @endyear = if endyear != '0' then endyear else nil end
      end
    end

    def to_h
      { '@sid': @sid, '@name': @name, '@startyear': @startyear, '@endyear': @endyear,
        '@episodelist': @episodelist }
    end

    def serialise
      fetch_episodes if @episodelist.nil? || @episodelist.empty?
      hash = self.to_h
      hash2 = serialise_episode_list hash
      hash2.to_json
    end

    def self.deserialise string
      hash = JSON.parse string
      temp_obj = Show.new nil
      hash.each do |key, val|
        temp_obj.instance_variable_set key, val
      end
      obj = deserialise_episode_list temp_obj
      obj
    end

    def fetch_episodes
      @episodelist = filter_episode_list get_episode_list
    end

    def random_episode
      fetch_episodes if @episodelist.nil? || @episodelist.empty?
      begin
        random_index = rand(0..@episodelist.length - 1)
        ep = @episodelist[random_index]
      end while ep.airdate > Date.today
      ep
    end

    private

    def self.deserialise_episode_list obj
      new_eplist = []
      obj.episodelist.each do |ep|
        new_eplist << Episode.deserialise(ep)
      end
      obj.episodelist = new_eplist
      obj
    end

    def serialise_episode_list hash
      new_eplist = []
      hash[:@episodelist].each do |ep|
        new_eplist << ep.serialise
      end
      hash[:@episodelist] = new_eplist
      hash
    end

    def get_show_info
      xmlres = RestClient.get "#{API_URL}/showinfo.php", params: { 'sid': @sid }
      parsed_result = Nokogiri::XML xmlres
      name = parsed_result.css('showname').text
      started = parsed_result.css('started').text
      if parsed_result.css('ended').children.equal? []
        ended = nil
      else
        begin
          ended = Date.parse(parsed_result.css('ended').text).year.to_s
        rescue ArgumentError
          ended = parsed_result.css('ended').text
        end
      end
      { 'name': name, 'started': started, 'ended': ended }
    end

    def get_episode_list
      xmlres = RestClient.get("#{API_URL}/episode_list.php", params: { "sid": @sid })
      parsed_result = Nokogiri::XML xmlres
      parsed_result
    end

    def filter_episode_list(listresult)
      result = []
      listresult.css('Episodelist Season').each do |s|
        season_no = s.attributes['no'].to_s
        s.element_children.each do |ep|
          title = ep.css('title').text
          season_episode = ep.css('seasonnum').text
          begin
            airdate = Date.parse ep.css('airdate').text
          rescue ArgumentError
            airdate = ep.css('episode airdate').text
          end

          result << Episode.new(season_no, season_episode, title, airdate)
        end
      end
      result
    end
  end

  class Search
    attr_accessor :term

    def initialize(sterm)
      @term = sterm
    end

    def execute
      filter_search_results get_search_results
    end

    #private

    def get_search_results
      xmlres = RestClient.get "#{API_URL}/search.php", params: { "show": @term }
      parsed_result = Nokogiri::XML xmlres
      parsed_result
    end

    def filter_search_results(searchresults)
      result = []
      searchresults.css('show').each do |sh|
        sid = sh.css('showid').text
        name = sh.css('name').text
        started = sh.css('started').text
        ended = sh.css('ended').text

        result << Show.new(sid, name, started, ended)
      end
      result
    end
  end
end
