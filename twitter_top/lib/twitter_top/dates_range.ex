defmodule TwitterTop.DatesRange do
  @dateshift 3

  def generate_dates(end_date) do
    Timex.Interval.new(from: end_date, until: Timex.now, right_open: false)
    |> Timex.Interval.with_step([days: @dateshift])
    |> Stream.chunk_every(2)
    |> Stream.map(fn range ->
        case range do
          [since, until] -> %{since: since |> format_range, until: until |> format_range}
          [since] -> %{since: since |> format_range, until: Timex.now |> format_range}
        end
      end)
  end

  defp format_range(date) do
    Timex.format!(date, "%Y-%m-%d", :strftime)
  end
end
