defmodule TwitterTop.Store do
  def receive_tweets([head | tail]) do
    IO.puts "Got tweet: " <> inspect head
    receive_tweets(tail)
  end

  def receive_tweets([]) do
    IO.puts "Finished"
  end
end
