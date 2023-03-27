defmodule B1Web.HangmanHTML do
  use B1Web, :html

  embed_templates "hangman_html/*"

  def plural_phrase(1, noun), do: "one #{noun}"
  def plural_phrase(n, _noun) when n < 0 do
    "<p class='bg-red-600'>Invalid</p>" |> raw()
  end
  def plural_phrase(n, noun), do: "#{n} #{noun}s"
end
