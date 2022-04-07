defmodule Sup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: S.task_sup()},
      {Finch, name: S.finch()},
      Supervisor.child_spec({Sup.Worker, name: :worker1}, id: :worker1),
      Supervisor.child_spec({Sup.Worker, name: :worker2}, id: :worker2),
      :systemd.ready()
    ]

    # for n <- [:alice@mac3, :bob@mac3] do
    #   Node.connect(n)
    # end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
