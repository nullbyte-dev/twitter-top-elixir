defmodule TwitterTop.Requester do

  @user_agents [
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/62.0.3202.62 Chrome/62.0.3202.62 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36",
    "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:56.0) Gecko/20100101 Firefox/56.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36"
  ]

  def get(url) do
    IO.puts url
    case HTTPoison.get(url, generate_headers(), [follow_redirect: true]) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in 200..299 ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: code}} when code in 400..499 ->
        {:abort, "BAD REQUEST"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:retry, reason}
    end
  end

  defp generate_headers do
    [
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36",
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Charset": "ISO-8859-1,utf-8;q=0.7,*;q=0.3",
      "Accept-Encoding": "none",
      "Accept-Language": "en-US,en;q=0.8",
      "Connection": "keep-alive"
    ]
  end
end
