defmodule Dictionary.Impl.WordList do

  @file_location Path.expand("./assets/words.txt")

  def word_list do
    "/home/swin/code/elixir/hangman/dictionary/assets/words.txt"
    |> File.read!() 
    |> String.split("\n", trim: true)  
  end
  
  def random_word(word_list) do
    word_list 
    |> Enum.random()
  end

end