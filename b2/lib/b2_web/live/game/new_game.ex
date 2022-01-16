defmodule B2Web.Live.Game.NewGame do
  use B2Web, :live_component

  def render(assigns) when assigns.tally.game_state == :won do
    ~H"""
    <div class="new_game" phx-click="new_game">
    <p>Congratulations on winning.</p>
      <p>Would you like to get a new word?</p>
    </div>
    """
  end

  def render(assigns) when assigns.tally.game_state == :lost do
    ~H"""
    <div class="new_game" phx-click="new_game">
    <p>Sorry, you didn't win.</p>
      <p>Would you like to get a new word?</p>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div>
    <p> Type a letter or click on a letter above to make a guess.</p>
     <div class="new_game" phx-click="new_game">Click here if you want to give up and get a new word.</div>
       </div>
    """
  end
end
