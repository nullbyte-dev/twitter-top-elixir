defmodule TwitterTop do
  @moduledoc """
  Documentation for TwitterTop.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TwitterTop.hello
      :world

  """
  alias TwitterTop.Requester, as: Requester
  alias TwitterTop.Parser, as: Parser
  alias TwitterTop.Store, as: Store

  @service_url "https://twitter.com/"
  @search_endpoint @service_url <> "search"
  @search_params [
    {"l", ""},
    {"src", "typd"},
    {"q", ""}
  ]

  def start(account \\ "norimyxxxo") do
    IO.puts "Starting for account: #{account}"
    get_tweets(account)
    IO.puts "Stopping for account: #{account}"
  end

  defp get_tweets(account) do
    case Requester.get(@service_url <> account) do
      {:ok, html} ->
        Parser.extract_tweets(html) |> Store.receive_tweets
    end
  end

end
