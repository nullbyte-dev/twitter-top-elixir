defmodule TwitterTop.Requester do
  def get(url, params \\ []) do
    case HTTPoison.get(url, params, follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in 200..299 ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:abort, "Not found :("}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:retry, reason}
    end
  end
end
