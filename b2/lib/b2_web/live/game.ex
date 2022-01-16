defmodule B2Web.Live.Game do
  use B2Web, :live_view

  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    socket = socket |> assign(%{game: game, tally: tally, graphical: true})
    {:ok, socket}
  end

  def handle_event("make_move", %{"key" => key}, socket) do
    tally = Hangman.make_move(socket.assigns.game, key)
    {:noreply, assign(socket, :tally, tally)}
  end

  def handle_event("toggle_graphical", _, socket) do
    IO.puts("something something something")
    {:noreply, assign(socket, :graphical, !socket.assigns.graphical)}
  end

  def handle_event("new_game", _, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    socket = socket |> assign(%{game: game, tally: tally})
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="game-holder" phx-window-keyup="make_move">
      <div class="toggle_graphical" phx-click="toggle_graphical">Click here to change view to 
    <%= if assigns.graphical do %>
      the old-school ascii view.
      <% else %>
      the new-wave svg view.
      <% end %>
    <p> </p>
    </div>
      <%= live_component(__MODULE__.Figure, tally: assigns.tally, graphical: assigns.graphical, id: 1) %> 
      <%= live_component(__MODULE__.Alphabet, tally: assigns.tally, id: 2) %> 
      <%= live_component(__MODULE__.WordSoFar, tally: assigns.tally, id: 3) %> 
      <%= live_component(__MODULE__.NewGame, tally: assigns.tally, id: 4) %>
    </div>
    """
  end
end
