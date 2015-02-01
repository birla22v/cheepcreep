require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
  class GithubUser < ActiveRecord::Base
    validates :login, presence: true
  end
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
  basic_auth ENV['GITHUB_USER'], ENV['GITHUB_PASS']

  def get_all_followers(user_name, page=1, per_page=20)
    options={:query => {:page => page, :per_page => per_page}}
    result = self.class.get("/users/#{user_name}/followers", options)
    json = JSON.parse(result.body)
    json.each do |follower|
      puts follower['login']
    end
  end

  def user_data(user_name)
    Cheepcreep::GithubUser.create(:login => json['login'],
    :name          => json['name'],
    :blog          => json['blog'],
    :followers     => json['followers'],
    :following     => json['following'],
    :public_repos  => json['public_repos'])
  end

  def get_followers(user_name, num_followers=20)
    get_all_followers(user_name).sample(20)
  end

  def get_gists(screen_name)
    options = {:basic_auth => @auth}
    result = self.class.get("/users/#{screen_name}/gists", options)
    json = JSON.parse(result.body)
  end
end

binding.pry

class CheepcreepApp
end

github = Github.new
Cheepcreep::GithubUser.create()
binding.pry

# creeper = CheepcreepApp.new
# creeper.creep
#
# github = Github.new
# resp = github.get_followers('redline6561')
# followers = JSON.parse(resp.body)
# CheepCreep::GithubUser:
