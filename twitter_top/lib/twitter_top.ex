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
  require Logger

  alias TwitterTop.{Requester, Aggregate, Parser, Store, DatesRange}

  @service_url "https://twitter.com/"
  @search_endpoint @service_url <> "search"
  @search_params [
    {:l, ""},
    {:src, "typd"},
    {:q, ""}
  ]

  def start(account \\ "norimyxxxo") do
    Logger.info "Starting for account: #{account}"

    account
    |> hold_account
    |> stream_tweets
    |> aggregate_words
    |> store_results

    Logger.info "Stopping for account: #{account}"
  end

  defp hold_account(account) do
    case Requester.get(@service_url <> account) do
      {:ok, html} ->
        html
        |> Parser.extract_account
        |> (fn x -> Agent.start_link(fn -> x end) end).()
    end
  end

  defp stream_tweets({:ok, agent}) do
    with name <- Agent.get(agent, fn x -> x.name end),
         created_at <- Agent.get(agent, fn x -> x.created_at end) do

      for d <- DatesRange.generate_dates(created_at) do
        IO.puts inspect d
        case Requester.get(@search_endpoint <> "?l=&src=typd&q=from:#{name}%20since:#{d.since}%20until:#{d.until}") do
          {:ok, html} ->
            Parser.extract_tweets(html)
            |> IO.puts(&inspect(&1))
          {:retry, reason} -> IO.puts inspect reason
          {:abort, reason} -> IO.puts inspect reason
        end

      end
    end
  end

  defp aggregate_words(stream) do
    Stream.map(stream, &Aggregate.count_words/1)
  end

  defp store_results(stream) do
    Enum.map(stream, &Store.receive_tweet/1)
  end

end
