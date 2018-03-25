defmodule TwitterTop.Store do
  require Logger

  # def receive_tweets([head | tail]) do
  #   Logger.info "Got tweet: " <> inspect head
  #   receive_tweets(tail)
  # end

  # def receive_tweets([]) do
  # end

  def receive_tweet(tweet) do
    Logger.info "Got tweet: " <> inspect tweet
  end
end
