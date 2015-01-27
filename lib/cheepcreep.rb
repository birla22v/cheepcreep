require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
end

#resp = HTTParty.get('https://')
#resp.headers['x-ratelimit-remaining']
#resp = HTTParty.get(base_uri + '/users/redline6561')
#resp.code
#resp.body
#JSON.parse(resp.body)['name']
class Github
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize
    # ENV["FOO"] is like echo $FOO
    @auth = {:username => ENV['GITHUB_USER'], :password => ENV['GITHUB_PASS']}
  end

  def user_data(screen_name)
    options = {:basic_auth => @auth}
    result = self.class.get("/users/#{screen_name}", options)
  end

  def get_followers(screen_name)
    followers = []
    options = ({:basic_auth => @auth})
    result = self.class.get("/users/#{screen_name}/followers", options)
    json = JSON.parse(result.body)
    followers.sample(20).each do |f|
      followers << f[result['login']]
    end
    puts followers
  end

  def get_user(screen_name)
    result = user_data(screen_name)['login']
  end

  def get_gists(screen_name)
    options = {:basic_auth => @auth}
    result = self.class.get("/users/#{screen_name}/gists", options)
    json = JSON.parse(result.body)
    binding.pry
  end
end

class CheepcreepApp
end


binding.pry

# creeper = CheepcreepApp.new
# creeper.creep
#
# github = Github.new
# resp = github.get_followers('redline6561')
# followers = JSON.parse(resp.body)
# CheepCreep::GithubUser:
