defmodule ComputerPlayer do
  @spec start() :: :ok
  defdelegate start(), to: ComputerPlayer.Impl.Player
end
