defmodule ComputerPlayer.Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep state :: {game, tally}
  @typep strategy :: :random | :weighted | :word_len | {:invalid, String.t()}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    strategy = get_strategy()

    play({game, tally, strategy})
  end

  #####################################################################
  #                             SETUP                                 #
  #####################################################################
  @spec get_strategy() :: strategy
  defp get_strategy() do
    IO.ANSI.format([
      :blue,
      :encircled,
      "Please choose your computer agent's guessing strategy. Choose:\n",
      :cyan,
      "1",
      :blue,
      " for random guessing,\n",
      :cyan,
      "2",
      :blue,
      " for letter frequency weighted guessing, or\n",
      :cyan,
      "3",
      :blue,
      " for letter frequency weighted guessing specific to words of your puzzle's size.\n"
    ])
    |> IO.gets()
    |> String.trim()
    |> check_strategy()
  end

  @spec check_strategy(String.t()) :: strategy
  defp check_strategy(n) when n in ["1", "2", "3"], do: parse_strategy(n)

  defp check_strategy(_n) do
    IO.ANSI.format([
      :red,
      :cyan_background,
      "Sorry that is not a valid strategy. You must enter 1, 2, or 3."
    ])
    |> IO.puts()

    get_strategy()
  end

  @spec parse_strategy(String.t()) :: strategy
  defp parse_strategy("1"), do: :random
  defp parse_strategy("2"), do: :weighted
  defp parse_strategy("3"), do: :word_len
  defp parse_strategy(n), do: {:invalid, n}

  #####################################################################
  #                             PLAY                                  # 
  #####################################################################

  @spec play({game, tally, strategy}) :: :ok
  def play({game, tally, strategy}),
    do: TextClient.Impl.Player.interact({game, tally}, guesses(game, strategy))

  @spec guesses(game, strategy) :: [String.t()]
  defp guesses(_, :random) do
    ?a..?z |> Enum.shuffle() |> Enum.map(fn n -> <<n>> end)
  end

  defp guesses(_, :weighted) do
    Dictionary.all_words()
    |> weighted_letters()
  end

  defp guesses(game, :word_len) do
    Dictionary.all_words_of_len(game.letters |> length())
    |> weighted_letters
  end

  defp weighted_letters(char_bank) do
    char_bank
    |> Enum.join("")
    |> String.codepoints()
    |> Enum.frequencies()
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.map(&elem(&1, 0))
  end
end
