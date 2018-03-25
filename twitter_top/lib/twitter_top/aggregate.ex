defmodule TwitterTop.Aggregate do
  def count_words(tweet) do
    tweet.text
    |> String.split
    |> sanitize
    |> (fn words ->
          Stream.map(words, fn w ->
              {w, Enum.count(words, &(&1 == w))}
          end)
        end).()
    |> Map.new
  end

  defp sanitize(list_of_words) do
    list_of_words
    |> Stream.map(fn x -> String.downcase(x) end)
    |> Stream.filter(fn x -> !url?(x) end)
    |> Stream.filter(fn x -> String.length(x) > 2 end)
  end

  defp url?(potential_url) do
    case URI.parse(potential_url) do
      %URI{scheme: nil} -> false
      %URI{host: nil} -> false
      %URI{path: nil} -> false
      _ -> true
    end
  end
end
