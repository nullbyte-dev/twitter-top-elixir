defmodule TwitterTop.Parser do
  alias TwitterTop.Entities.Account, as: Account
  alias TwitterTop.Entities.Tweet, as: Tweet

  def extract_account(html) do
    {:ok, %Account{}}
  end

  def extract_tweets(html) do
    Floki.find(html, "div.js-stream-tweet")
    |> Enum.map(fn tweet_html ->
      %Tweet{
        id: Floki.attribute(tweet_html, "data-item-id"),
        text: Floki.find(tweet_html, ".js-tweet-text") |> Floki.text,
        timestamp: Floki.find(tweet_html, "._timestamp") |> Floki.attribute("data-time")
      }
    end)
  end
end
