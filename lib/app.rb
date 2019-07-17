require 'dotenv'# Appelle la gem Dotenv
require 'twitter' # Appelle la gem Twitter
require './journalist.rb'

Dotenv.load('../.env') # Ceci appelle le fichier .env (situé dans le même dossier que celui d'où tu exécute app.rb)
# et grâce à la gem Dotenv, on importe toutes les données enregistrées dans un hash ENV

local_dir = File.expand_path('../', __FILE__) #Ceci permet d'utiliser des variables globales (utilisable dans toutes les def)
$LOAD_PATH.unshift(local_dir)

# Il est ensuite très facile d'appeler les données du hash ENV, par exemple là je vais afficher le contenu de la clé TWITTER_API_SECRET
def initialize_var
  @client = login_twitter
  @hashtag = '#bonjour_monde'
  @client_stream = login_twitter_streaming
end
  

def login_twitter
client = Twitter::REST::Client.new do |config|local_dir = File.expand_path('../', __FILE__)
  $LOAD_PATH.unshift(local_dir)
    config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
    config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
    config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
    config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
  end
  client
end

def login_twitter_streaming
  client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
    end
    client
  end

  # ligne qui permet de tweeter sur ton compte
def tweet_perso
  @client.update('Mon deuxième tweet en Ruby !!!!')
end

  ##############################################################
  #Dis Bonjour
def tweet_journalist
  journalist.sample(5).map{|n| @client.update("#{n} I love your work! @the_hacking_pro #{@hashtag}")}
end

  ##############################################################
  # Like les 25 derniers tweets avec le hashtag bonjour_monde
def favorite_recent
  @client.search("#{@hashtag}", result_type:"recent").take(25).each{|tweet| client.favorite(tweet)}
end

  ##############################################################
  # Follow les 20 dernières personnes ayant tweeté bonjour_monde
def follow_recent
  @client.search("#{@hashtag}", result_type:"recent").take(3).collect do |tweet| @client.follow(tweet.user) 
    end
end


  ##############################################################
  # Like les tweets et follow les twittos utilisant le bonjour_monde en direct
def streaming
  @client_stream.filter(track:"#{@hashtag}") do |tweet| 
    puts "#{tweet.text}"
    @client.favorite(tweet)
    @client.follow(tweet.user)
  end  
end

def master
  initialize_var
  streaming
end

master