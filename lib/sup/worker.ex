defmodule Sup.Worker do
  @moduledoc false
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  @impl true
  def init(opts) do
    Process.flag(:trap_exit, true)
    Bot.send_message("starting #{opts[:name]} on #{node()}")
    {:ok, opts}
  end

  @impl true
  def terminate(reason, state) do
    Bot.send_message("stopping #{inspect(reason: reason, state: state)} on #{node()}")
    state
  end
end
