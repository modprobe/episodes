# episodes

Small [Sinatra](http://www.sinatrarb.com/) project using the [TVRage API](http://services.tvrage.com/) to find TV shows and a list of their episodes.

## "home use"
```
$ git clone https://github.com/modprobe/episodes.git
$ cd episodes/
$ bundle install
$ bundle exec ruby episodes.rb
```

## Deploy to heroku
1. Clone the repo and add a new heroku app.

    ```
    $ git clone https://github.com/modprobe/episodes.git
    $ cd episodes/
    $ heroku apps:create [APPNAME, e.g. 'modprobe-episodes']
    ```
2. You'll need to add a Redis addon to your app. Redis to Go offers a free plan you can use as a starting point:
    
    ```
    $ heroku addons:add redistogo:nano
    ```
3. Find out the Redis URL:
    
    ```
    $ heroku config --app [APPNAME]
      REDISTOGO_URL              => redis://redistogo:44ec0bc04dd4a5afe77a649acee7a8f3@drum.redistogo.com:9092/
    ```
4. You'll have to setup Episodes to use that url:
    
    ```
    $ vim episodes.rb
    ```
   Replace `Redis.new` with `Redis.new(url: ENV['REDISTOGO_URL'])` in line 11.
5. Ready to push!
    
    ```
    $ git push heroku
    ```
You should see something like
```
remote: -----> Launching... done, v4
remote:        https://[NAME].herokuapp.com/ deployed to Heroku
```
You can then click the link to see the landing page.

## Deploy to dokku
If you run your own [dokku](https://github.com/progrium/dokku) server, you can deploy to that as well.
Installing redis on dokku is much easier, just follow the installation instructions at the [dokku-redis-plugin repo](https://github.com/luxifer/dokku-redis-plugin#installation). Then:
```
$ git clone https://github.com/modprobe/episodes.git
$ cd episodes/
$ git remote add dokku dokku@[DOKKU-DOMAIN, e.g. modprobe.me]:[NAME, e.g. episodes]
$ git push dokku
```

