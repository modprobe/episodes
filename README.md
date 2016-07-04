# DEPRECATED

The TVRage API has been shut down and as a consequence this app is now worthless. Someday™ I'll maybe update this to use another API, but this day is not today.

## episodes

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
3. You'll have to setup Episodes to use that url:
    
    ```
    $ vim episodes.rb
    ```
    Uncomment the lines in the `configuration` section and comment out the line above.
4. Ready to push!
    
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

