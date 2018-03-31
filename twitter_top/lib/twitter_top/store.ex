defmodule TwitterTop.Store do
  require Logger

  def receive_tweet(tweet) do
    Logger.info "Got tweet: " <> inspect tweet
  end
end
