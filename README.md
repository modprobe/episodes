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
```
$ git clone https://github.com/modprobe/episodes.git
$ cd episodes/
$ heroku apps:create [NAME, e.g. 'episodes']
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
```
$ git clone https://github.com/modprobe/episodes.git
$ cd episodes/
$ git remote add dokku dokku@[DOKKU-DOMAIN, e.g. modprobe.me]:[NAME, e.g. episodes]
```

