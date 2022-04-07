defmodule AWS.ELB do
  @moduledoc false
  alias AWS.Request
  alias AWS.Client

  def metadata do
    %AWS.ServiceMetadata{
      abbreviation: "Elastic Load Balancing v2",
      api_version: "2015-12-01",
      content_type: "application/x-www-form-urlencoded",
      credential_scope: nil,
      endpoint_prefix: "elasticloadbalancing",
      global?: false,
      protocol: "query",
      service_id: "Elastic Load Balancing v2",
      signature_version: "v4",
      signing_name: "elasticloadbalancing",
      target_prefix: nil
    }
  end

  def deregister_targets(%Client{} = client, input, options \\ []) do
    Request.request_post(client, metadata(), "DeregisterTargets", input, options)
  end

  def register_targets(%Client{} = client, input, options \\ []) do
    Request.request_post(client, metadata(), "RegisterTargets", input, options)
  end
end
