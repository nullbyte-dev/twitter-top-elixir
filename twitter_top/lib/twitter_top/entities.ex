defmodule TwitterTop.Entities.Tweet do
  defstruct id: nil, text: nil, timestamp: nil
end

defmodule TwitterTop.Entities.Account do
  defstruct screen_name: nil, created_at: nil, statuses_count: 0
end
