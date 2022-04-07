import Config

config :sup,
  bot_token: System.fetch_env!("TG_BOT_KEY"),
  bot_room_id: System.fetch_env!("TG_ROOM_ID")
