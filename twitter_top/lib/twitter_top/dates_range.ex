defmodule TwitterTop.DatesRange do
  @dateshift 3

  def generate_dates(end_date) do
    Timex.Interval.new(from: end_date, until: Timex.now, right_open: false)
    |> Timex.Interval.with_step([days: @dateshift])
    |> Stream.chunk_every(2)
    |> Stream.map(fn [since, until] ->
         %{since: Timex.format!(since, "%Y-%m-%d", :strftime),
           until: Timex.format!(until, "%Y-%m-%d", :strftime)}
       end)
  end
end
