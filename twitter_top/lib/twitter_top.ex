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
  @service_url "https://twitter.com/"
  @search_endpoint @service_url <> "search"

  require Logger

  alias TwitterTop.{Requester, Aggregate, Parser, Store, DatesRange}

  def start(account \\ "norimyxxxo") do
    Logger.info "Starting for account: #{account}"

    workflow(account)

    Logger.info "Stopping for account: #{account}"
  end

  def workflow(account) do
    # TODO: one request worker, many processing workers
    # OR:
    # Scrap proxies
    # Agent for holding links [random get url]
    # Agent for holding tweets ID
    # Agent for holding ALL tweets and dump on every xxx tweets (holder)
    # Profile -> get user's tweets count
    account
    |> get_account
    |> generate_urls
    |> Enum.map(fn url ->
        url
        |> get_tweets_from_url
        |> aggregate_words
        |> store_results
      end)
  end

  defp get_account(account) do
    @service_url <> account
    |> Requester.get!
    |> Parser.extract_account
  end

  defp generate_urls(profile) do
    profile.created_at
    |> DatesRange.generate_dates
    |> Stream.map(fn d ->
         @search_endpoint <> "?l=&src=typd&q=" <>
                             "from:#{profile.screen_name}%20" <>
                             "since:#{d.since}%20until:#{d.until}"
       end)
  end

  def get_tweets_from_url(search_url) do
    search_url |> Requester.get! |> Parser.extract_tweets
  end

  defp aggregate_words(stream) do
    stream |> Stream.map(&Aggregate.count_words/1)
  end

  defp store_results(stream) do
    stream |> Stream.map(&Store.receive_tweet/1)
  end
end
