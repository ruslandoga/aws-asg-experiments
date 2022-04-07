defmodule Bot do
  @moduledoc false
  @finch S.Finch

  def token do
    Application.fetch_env!(:sup, :bot_token)
  end

  def room_id do
    Application.fetch_env!(:sup, :bot_room_id)
  end

  # https://core.telegram.org/bots/api#sendmessage
  def send_message(chat_id \\ room_id(), text, opts \\ []) do
    payload = Enum.into(opts, %{"chat_id" => chat_id, "text" => text})
    request("sendMessage", payload)
  end

  defp request(method, body) when is_map(body) do
    request(method, [{"content-type", "application/json"}], Jason.encode_to_iodata!(body))
  end

  defp request(method, headers, body) do
    req = Finch.build(:post, build_url(method), headers, body)
    Finch.request(req, @finch, receive_timeout: 20_000)
  end

  defp build_url(method) do
    "https://api.telegram.org/bot" <> token() <> "/" <> method
  end
end
