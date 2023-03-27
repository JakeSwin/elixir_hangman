defmodule B1Web.HangmanController do
  use B1Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def new(conn, _params) do
    game = Hangman.new_game()
    put_session(conn, :game, game)
    render(conn, :game, layout: false)
  end
end
