defmodule HangmanImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new
    assert game.turns_left == 7
    assert game.game_state == :initialising
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Game.new("wombat")
    assert game.turns_left == 7
    assert game.game_state == :initialising
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new("wombat")
      game = Map.put(game, :game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "y")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters used" do
    game = Game.new()
    { game, _tally } = Game.make_move(game, "x")
    { game, _tally } = Game.make_move(game, "y")
    { game, _tally } = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new("wombat")
    { game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    { game, _tally } = Game.make_move(game, "t")
    assert game.game_state == :good_guess
  end

  test "we recognize a letter not in the word" do
    game = Game.new("wombat")
    turns_left = game.turns_left
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == turns_left - 1
  end

  test "can handle playing game" do
    [
      ["h", :good_guess  , 7, ["h", "_", "_", "_", "_"], ["h"]],
      ["x", :bad_guess   , 6, ["h", "_", "_", "_", "_"], ["h", "x"]],
      ["x", :already_used, 6, ["h", "_", "_", "_", "_"], ["h", "x"]],
      ["l", :good_guess  , 6, ["h", "_", "l", "l", "_"], ["h", "l", "x"]]
    ]
    |> test_sequence_of_moves("hello")
  end

  test "can handle winning game" do
    [
      ["t", :good_guess  , 7, ["t", "_", "_", "t"], ["t"]],
      ["z", :bad_guess   , 6, ["t", "_", "_", "t"], ["t", "z"]],
      ["z", :already_used, 6, ["t", "_", "_", "t"], ["t", "z"]],
      ["e", :good_guess  , 6, ["t", "e", "_", "t"], ["e", "t", "z"]],
      ["s", :won         , 6, ["t", "e", "s", "t"], ["e", "s", "t", "z"]],
    ]
    |> test_sequence_of_moves("test")
  end

  test "can handle losing game" do
    [
      ["a", :bad_guess , 6, ["_", "_", "_"], ["a"]],
      ["b", :bad_guess , 5, ["_", "_", "_"], ["a", "b"]],
      ["c", :bad_guess , 4, ["_", "_", "_"], ["a", "b", "c"]],
      ["d", :bad_guess , 3, ["_", "_", "_"], ["a", "b", "c", "d"]],
      ["e", :bad_guess , 2, ["_", "_", "_"], ["a", "b", "c", "d", "e"]],
      ["f", :bad_guess , 1, ["_", "_", "_"], ["a", "b", "c", "d", "e", "f"]],
      ["g", :lost      , 0, ["z", "i", "z"], ["a", "b", "c", "d", "e", "f", "g"]],
    ]
    |> test_sequence_of_moves("ziz")
  end

  def test_sequence_of_moves(script, word) do
    game = Game.new(word)
    Enum.reduce(script, game, &check_one_move/2)
  end

  def check_one_move([ guess, state, turns, letters, used ], game) do
    { game, tally } = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end
end

