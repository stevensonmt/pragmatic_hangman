defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  @spec interact(state) :: :ok

  def interact({_, tally = %{game_state: :won}}) do
    IO.ANSI.format([
      :cyan,
      "#{tally.letters |> Enum.join() |> String.upcase()}",
      :blue,
      " is correct!\n",
      :cyan_background,
      :black,
      "Congratulations. You won!"
    ])
    |> IO.puts()
  end

  def interact({_, tally = %{game_state: :lost}}) do
    IO.ANSI.format([
      :red,
      :white_background,
      "Sorry, you lost. The word was: ",
      :red_background,
      :white,
      "#{tally.letters |> Enum.join()}"
    ])
    |> IO.puts()
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    Hangman.make_move(game, get_guess())
    |> interact()
  end

  @spec interact(state, []) :: :ok

  def interact({_, tally = %{game_state: :won}}, _) do
    IO.ANSI.format([
      :cyan,
      "#{tally.letters |> Enum.join() |> String.upcase()}",
      :blue,
      " is correct!\n",
      :cyan_background,
      :black,
      "Congratulations. You won!"
    ])
    |> IO.puts()
  end

  def interact({_, tally = %{game_state: :lost}}, _) do
    IO.ANSI.format([
      :red,
      :white_background,
      "Sorry, you lost. The word was: ",
      :red_background,
      :white,
      "#{tally.letters |> Enum.join()}"
    ])
    |> IO.puts()
  end

  def interact({game, tally}, [guess | guesses]) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    Hangman.make_move(game, guess)
    |> interact(guesses)
  end

  def feedback_for(tally = %{game_state: :initializing}) do
    IO.ANSI.format([:cyan, "Welcome! I'm thinking of a #{tally.letters |> length()}-letter word."])
  end

  def feedback_for(%{game_state: :good_guess}), do: IO.ANSI.format([:cyan, "Good guess!"])

  def feedback_for(%{game_state: :bad_guess}),
    do: IO.ANSI.format([:magenta, "Sorry, that letter's not in the word."])

  def feedback_for(%{game_state: :already_used}),
    do: IO.ANSI.format([:green, "You already used that letter."])

  def current_word(tally) do
    IO.ANSI.format([
      :green,
      [
        "Word so far: ",
        tally.letters |> Enum.join(" "),
        "    turns left: ",
        tally.turns_left |> to_string(),
        "    used so far: ",
        tally.used |> Enum.join(",")
      ]
    ])
  end

  def get_guess() do
    IO.ANSI.format([:blue, :encircled, "Next letter: "])
    |> IO.gets()
    |> String.trim()
    |> String.downcase()
  end
end
