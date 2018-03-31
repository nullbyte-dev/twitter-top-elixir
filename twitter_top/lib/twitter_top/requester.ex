defmodule TwitterTop.Requester do

  @user_agents [
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/62.0.3202.62 Chrome/62.0.3202.62 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36",
    "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:56.0) Gecko/20100101 Firefox/56.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36"
  ]

  defp generate_headers do
    [
      "User-Agent": Enum.random(@user_agents),
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Charset": "ISO-8859-1,utf-8;q=0.7,*;q=0.3",
      "Accept-Encoding": "none",
      "Accept-Language": "en-US,en;q=0.8",
      "Connection": "keep-alive"
    ]
  end

  def get(url) do
    IO.puts "Going to GET: " <> url

    case HTTPoison.get(url, generate_headers()) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in 200..299 ->
        {:ok, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:abort, reason}
    end
  end

  def get!(url) do
    case get(url) do
      {:ok, body} -> body
      {:abort, reason} -> reason |> inspect |> (&(IO.puts &1)).()
      _ -> IO.puts "All matched case catch ..."
    end
  end

end
