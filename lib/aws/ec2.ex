defmodule AWS.EC2 do
  @moduledoc false
  alias AWS.Request

  def metadata do
    %AWS.ServiceMetadata{
      api_version: "2016-11-15",
      content_type: "text/xml",
      endpoint_prefix: "ec2",
      global?: false,
      protocol: "query",
      signing_name: "ec2"
    }
  end

  def describe_instances(client, input, options \\ []) do
    Request.request_post(client, metadata(), "DescribeInstances", input, options)
  end

  # def describe_network_interfaces(client, input, options \\ []) do
  #   Request.request_post(client, metadata(), "DescribeNetworkInterfaces", input, options)
  # end
end
