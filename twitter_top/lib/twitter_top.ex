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

  def start(account \\ "norimyxxxo") do
    Logger.info "Starting for account: #{account}"

    Task.async(__MODULE__, :workflow, [account])
    |> (fn {:ok, task} -> Task.await(task) end).()

    Logger.info "Stopping for account: #{account}"
  end

  def workflow(account) do
    # TODO: one request worker, many processing workers
    account
    |> hold_account
    |> generate_urls
    |> Enum.each(fn url ->
        Task.start(fn ->
          url
          |> IO.inspect
          |> get_tweets_from_url
          |> aggregate_words
          |> store_results
        end)
      end)
  end

  defp hold_account(account) do
    @service_url <> account |> Requester.get! |> Parser.extract_account
  end

  defp generate_urls(profile) do
    profile.created_at
    |> DatesRange.generate_dates
    |> Stream.map(fn d ->
         @search_endpoint <> "?l=&src=typd&q=" <>
                             "from:#{profile.name}%20" <>
                             "since:#{d.since}%20 until:#{d.until}"
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
