# HaproxyParser
HaproxyParser could get some paramerters from haproxy.cfg.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'haproxy_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install haproxy_parser

## Requirements
You must install haproxy command your machine.  Because this tool uses haproxy command when it check format of a haproxy coniguration file.

## Usage
### haproxy.cfg
In first, you should prepare haproxy configuration file from which you want to get information like below:
```
global
    log         127.0.0.1 local2

    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

frontend  frontend_http_80
    bind *:5000
    default_backend             backend_http_80

backend backend_http_80
    balance     roundrobin
    server  10.21.0.160:80 10.21.0.160:80 check
```

## Check Format
```
config = HaproxyParser.new(
  haproxy_config_path
).check_format!
```

### Execute Parse
You can parse by calling method like below.
```
config = HaproxyParser.new(
  haproxy_config_path
).parse
```

### Global Parameters
After calling `parse` method, you can access global informations through `global` method.
```
config.global.nbproc # => 1(default value)
config.global.maxconn # => 2000(default value)
```

### Frontend Parameters
Like `Global Parameters`, you can access frontend informations through `frontend` method.
```
config.frontend.name # => "frontend_http_80"
config.frontend.ipaddress # => "*"
...
```

### Backend Parameters
Backend Parameters are refered thorough `frontend` method.  
So you are not able to access Backend Parameter which are not refered from any `frontend`.  

```
config.frontends[0].backend.servers.each do |server|
  server.name # => "10.21.0.160:80"
  server.ipaddress # => "10.21.0.160"
  server.port # => "80"
  ....
end

config.frontends[0].backend.balance # => "roundrobin"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/haproxy_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

