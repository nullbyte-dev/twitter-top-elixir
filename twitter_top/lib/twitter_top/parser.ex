defmodule TwitterTop.Parser do
  alias TwitterTop.Entities.{Account, Tweet}

  def extract_account(html) do
    html
    |> Floki.find("input.json-data")
    |> Floki.attribute("value") |> Floki.text
    |> Poison.decode!([keys: :atoms])
    |> (fn json -> json.profile_user end).()
    |> (fn profile ->
          %Account{name: profile.screen_name,
                   created_at: profile.created_at
                               |> Timex.parse!("%a %b %d %H:%M:%S %z %Y", :strftime)}
        end).()
  end

  def extract_tweets(html) do
    html
    |> Floki.find("div.js-stream-tweet")
    |> Stream.map(fn tweet_html ->
      %Tweet{id: tweet_html
                 |> Floki.attribute("data-item-id")
                 |> Floki.text,
             text: tweet_html
                   |> Floki.find(".js-tweet-text")
                   |> Floki.text,
             timestamp: tweet_html
                        |> Floki.find("._timestamp")
                        |> Floki.attribute("data-time")
                        |> Floki.text}
    end)
  end
end
