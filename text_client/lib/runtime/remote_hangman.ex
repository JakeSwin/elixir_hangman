defmodule TextClient.Runtime.RemoteHangman do

  @remote_server :"hangman@DESKTOP-CLPHV1R"

  def connect() do
    :rpc.call(@remote_server, Hangman, :new_game, [])
  end

end