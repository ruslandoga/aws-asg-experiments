defmodule Mix.Tasks.Deploy do
  @moduledoc "Performs a rolling deploy via ssh"
  @shortdoc "Deploys the app"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    client = AWS.Client.create("eu-north-1")
    Mix.shell().info("Fetching running aws ec2 instances ...")
    {:ok, result, _resp} = AWS.EC2.describe_instances(client, %{})
    instances = []

    for instance <- instances do
      Mix.shell().info("Deploying [asdf] on #{instance.private_ip} ...")
      {:ok, result, _resp} = AWS.ELB.deregister_targets(client, %{})
      # TODO AWS.SSM.
      {:ok, conn} = :ssh.connect(to_charlist(instance.private_ip), 22, user: 'ubuntu')
      {:ok, result, _resp} = AWS.ELB.register_targets(client, %{})
      :ok = :ssh.close(conn)
      Mix.shell().info("Deployed [asdf] on #{instance.private_ip} ;)")
    end
  end
end
