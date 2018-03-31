defmodule TwitterTop.Parser do
  alias TwitterTop.Entities.{Account, Tweet}

  def extract_account(html) do
    html
    |> Floki.find("input.json-data")
    |> Floki.attribute("value") |> Floki.text
    |> Poison.decode!([keys: :atoms])
    |> get_in([:profile_user])
    |> (fn p ->
          %Account{name: p.screen_name, created_at: p.created_at |> parse_created}
        end).()
  end

  defp parse_created(raw) do
    Timex.parse!(raw, "%a %b %d %H:%M:%S %z %Y", :strftime)
  end

  def extract_tweets(html) do
    html
    |> Floki.find("div.js-stream-tweet")
    |> Stream.map(fn t ->
         %Tweet{
           id: t |> Floki.attribute("data-item-id") |> Floki.text,
           text: t |> Floki.find(".js-tweet-text") |> Floki.text,
           timestamp: t |> Floki.find("._timestamp") |> Floki.attribute("data-time") |> Floki.text
         }
       end)
  end
end
