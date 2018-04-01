defmodule TwitterTop.Aggregate do
  def count_words(tweet) do
    tweet.text
    |> String.split
    |> sanitize_text
    |> (fn words ->
          Stream.each(words, fn w ->
              {w, Enum.count(words, &(&1 == w))}
          end)
      end).()
    |> Map.new
  end

  defp sanitize_text(list_of_words) do
    list_of_words
    |> Stream.map(fn x -> String.downcase(x) end)
    |> Stream.filter(fn x -> !url?(x) end)
    |> Stream.filter(fn x -> String.length(x) > 2 end)
  end

  defp url?(maybe_url) do
    case URI.parse(maybe_url) do
      %URI{scheme: nil} -> false
      %URI{host: nil} -> false
      %URI{path: nil} -> false
      _ -> true
    end
  end
end
