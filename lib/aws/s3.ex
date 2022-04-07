defmodule AWS.S3 do
  @moduledoc false
  alias AWS.Client
  alias AWS.Request

  def metadata do
    %AWS.ServiceMetadata{
      abbreviation: nil,
      api_version: "2006-03-01",
      content_type: "text/xml",
      credential_scope: nil,
      endpoint_prefix: "s3",
      global?: false,
      protocol: "rest-xml",
      service_id: "S3",
      signature_version: "s3",
      signing_name: "s3",
      target_prefix: nil
    }
  end

  def delete_object(%Client{} = client, bucket, key, input, options \\ []) do
    url_path = "/#{AWS.Util.encode_uri(bucket)}/#{AWS.Util.encode_multi_segment_uri(key)}"

    {headers, input} =
      [
        {"BypassGovernanceRetention", "x-amz-bypass-governance-retention"},
        {"ExpectedBucketOwner", "x-amz-expected-bucket-owner"},
        {"MFA", "x-amz-mfa"},
        {"RequestPayer", "x-amz-request-payer"}
      ]
      |> Request.build_params(input)

    {query_params, input} =
      [
        {"VersionId", "versionId"}
      ]
      |> Request.build_params(input)

    options =
      Keyword.put(
        options,
        :response_header_parameters,
        [
          {"x-amz-delete-marker", "DeleteMarker"},
          {"x-amz-request-charged", "RequestCharged"},
          {"x-amz-version-id", "VersionId"}
        ]
      )

    Request.request_rest(
      client,
      metadata(),
      :delete,
      url_path,
      query_params,
      headers,
      input,
      options,
      204
    )
  end

  def delete_objects(%Client{} = client, bucket, input, options \\ []) do
    url_path = "/#{AWS.Util.encode_uri(bucket)}?delete"

    {headers, input} =
      [
        {"BypassGovernanceRetention", "x-amz-bypass-governance-retention"},
        {"ChecksumAlgorithm", "x-amz-sdk-checksum-algorithm"},
        {"ExpectedBucketOwner", "x-amz-expected-bucket-owner"},
        {"MFA", "x-amz-mfa"},
        {"RequestPayer", "x-amz-request-payer"}
      ]
      |> Request.build_params(input)

    query_params = []

    options =
      Keyword.put(
        options,
        :response_header_parameters,
        [{"x-amz-request-charged", "RequestCharged"}]
      )

    Request.request_rest(
      client,
      metadata(),
      :post,
      url_path,
      query_params,
      headers,
      input,
      options,
      nil
    )
  end

  def get_object(
        %Client{} = client,
        bucket,
        key,
        part_number \\ nil,
        response_cache_control \\ nil,
        response_content_disposition \\ nil,
        response_content_encoding \\ nil,
        response_content_language \\ nil,
        response_content_type \\ nil,
        response_expires \\ nil,
        version_id \\ nil,
        checksum_mode \\ nil,
        expected_bucket_owner \\ nil,
        if_match \\ nil,
        if_modified_since \\ nil,
        if_none_match \\ nil,
        if_unmodified_since \\ nil,
        range \\ nil,
        request_payer \\ nil,
        sse_customer_algorithm \\ nil,
        sse_customer_key \\ nil,
        sse_customer_key_md5 \\ nil,
        options \\ []
      ) do
    url_path = "/#{AWS.Util.encode_uri(bucket)}/#{AWS.Util.encode_multi_segment_uri(key)}"
    headers = []

    headers =
      if !is_nil(checksum_mode) do
        [{"x-amz-checksum-mode", checksum_mode} | headers]
      else
        headers
      end

    headers =
      if !is_nil(expected_bucket_owner) do
        [{"x-amz-expected-bucket-owner", expected_bucket_owner} | headers]
      else
        headers
      end

    headers =
      if !is_nil(if_match) do
        [{"If-Match", if_match} | headers]
      else
        headers
      end

    headers =
      if !is_nil(if_modified_since) do
        [{"If-Modified-Since", if_modified_since} | headers]
      else
        headers
      end

    headers =
      if !is_nil(if_none_match) do
        [{"If-None-Match", if_none_match} | headers]
      else
        headers
      end

    headers =
      if !is_nil(if_unmodified_since) do
        [{"If-Unmodified-Since", if_unmodified_since} | headers]
      else
        headers
      end

    headers =
      if !is_nil(range) do
        [{"Range", range} | headers]
      else
        headers
      end

    headers =
      if !is_nil(request_payer) do
        [{"x-amz-request-payer", request_payer} | headers]
      else
        headers
      end

    headers =
      if !is_nil(sse_customer_algorithm) do
        [{"x-amz-server-side-encryption-customer-algorithm", sse_customer_algorithm} | headers]
      else
        headers
      end

    headers =
      if !is_nil(sse_customer_key) do
        [{"x-amz-server-side-encryption-customer-key", sse_customer_key} | headers]
      else
        headers
      end

    headers =
      if !is_nil(sse_customer_key_md5) do
        [{"x-amz-server-side-encryption-customer-key-MD5", sse_customer_key_md5} | headers]
      else
        headers
      end

    query_params = []

    query_params =
      if !is_nil(version_id) do
        [{"versionId", version_id} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(response_expires) do
        [{"response-expires", response_expires} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(response_content_type) do
        [{"response-content-type", response_content_type} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(response_content_language) do
        [{"response-content-language", response_content_language} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(response_content_encoding) do
        [{"response-content-encoding", response_content_encoding} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(response_content_disposition) do
        [{"response-content-disposition", response_content_disposition} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(response_cache_control) do
        [{"response-cache-control", response_cache_control} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(part_number) do
        [{"partNumber", part_number} | query_params]
      else
        query_params
      end

    options =
      Keyword.put(
        options,
        :response_header_parameters,
        [
          {"x-amz-checksum-crc32c", "ChecksumCRC32C"},
          {"x-amz-delete-marker", "DeleteMarker"},
          {"x-amz-object-lock-retain-until-date", "ObjectLockRetainUntilDate"},
          {"x-amz-restore", "Restore"},
          {"x-amz-server-side-encryption-bucket-key-enabled", "BucketKeyEnabled"},
          {"Content-Type", "ContentType"},
          {"x-amz-server-side-encryption-customer-key-MD5", "SSECustomerKeyMD5"},
          {"x-amz-object-lock-legal-hold", "ObjectLockLegalHoldStatus"},
          {"x-amz-version-id", "VersionId"},
          {"accept-ranges", "AcceptRanges"},
          {"x-amz-website-redirect-location", "WebsiteRedirectLocation"},
          {"Content-Language", "ContentLanguage"},
          {"x-amz-server-side-encryption-customer-algorithm", "SSECustomerAlgorithm"},
          {"Content-Encoding", "ContentEncoding"},
          {"x-amz-checksum-sha256", "ChecksumSHA256"},
          {"ETag", "ETag"},
          {"Last-Modified", "LastModified"},
          {"Content-Range", "ContentRange"},
          {"Expires", "Expires"},
          {"x-amz-tagging-count", "TagCount"},
          {"x-amz-expiration", "Expiration"},
          {"x-amz-replication-status", "ReplicationStatus"},
          {"Cache-Control", "CacheControl"},
          {"x-amz-storage-class", "StorageClass"},
          {"x-amz-missing-meta", "MissingMeta"},
          {"Content-Length", "ContentLength"},
          {"x-amz-object-lock-mode", "ObjectLockMode"},
          {"Content-Disposition", "ContentDisposition"},
          {"x-amz-request-charged", "RequestCharged"},
          {"x-amz-server-side-encryption", "ServerSideEncryption"},
          {"x-amz-mp-parts-count", "PartsCount"},
          {"x-amz-server-side-encryption-aws-kms-key-id", "SSEKMSKeyId"},
          {"x-amz-checksum-crc32", "ChecksumCRC32"},
          {"x-amz-checksum-sha1", "ChecksumSHA1"}
        ]
      )

    options =
      Keyword.put(
        options,
        :receive_body_as_binary?,
        true
      )

    Request.request_rest(
      client,
      metadata(),
      :get,
      url_path,
      query_params,
      headers,
      nil,
      options,
      nil
    )
  end

  def list_objects_v2(
        %Client{} = client,
        bucket,
        continuation_token \\ nil,
        delimiter \\ nil,
        encoding_type \\ nil,
        fetch_owner \\ nil,
        max_keys \\ nil,
        prefix \\ nil,
        start_after \\ nil,
        expected_bucket_owner \\ nil,
        request_payer \\ nil,
        options \\ []
      ) do
    url_path = "/#{AWS.Util.encode_uri(bucket)}?list-type=2"
    headers = []

    headers =
      if !is_nil(expected_bucket_owner) do
        [{"x-amz-expected-bucket-owner", expected_bucket_owner} | headers]
      else
        headers
      end

    headers =
      if !is_nil(request_payer) do
        [{"x-amz-request-payer", request_payer} | headers]
      else
        headers
      end

    query_params = []

    query_params =
      if !is_nil(start_after) do
        [{"start-after", start_after} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(prefix) do
        [{"prefix", prefix} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(max_keys) do
        [{"max-keys", max_keys} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(fetch_owner) do
        [{"fetch-owner", fetch_owner} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(encoding_type) do
        [{"encoding-type", encoding_type} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(delimiter) do
        [{"delimiter", delimiter} | query_params]
      else
        query_params
      end

    query_params =
      if !is_nil(continuation_token) do
        [{"continuation-token", continuation_token} | query_params]
      else
        query_params
      end

    Request.request_rest(
      client,
      metadata(),
      :get,
      url_path,
      query_params,
      headers,
      nil,
      options,
      nil
    )
  end

  def put_object(%Client{} = client, bucket, key, input, options \\ []) do
    url_path = "/#{AWS.Util.encode_uri(bucket)}/#{AWS.Util.encode_multi_segment_uri(key)}"

    {headers, input} =
      [
        {"ChecksumAlgorithm", "x-amz-sdk-checksum-algorithm"},
        {"SSECustomerKey", "x-amz-server-side-encryption-customer-key"},
        {"GrantFullControl", "x-amz-grant-full-control"},
        {"ACL", "x-amz-acl"},
        {"ChecksumCRC32C", "x-amz-checksum-crc32c"},
        {"ObjectLockRetainUntilDate", "x-amz-object-lock-retain-until-date"},
        {"RequestPayer", "x-amz-request-payer"},
        {"BucketKeyEnabled", "x-amz-server-side-encryption-bucket-key-enabled"},
        {"ContentType", "Content-Type"},
        {"SSECustomerKeyMD5", "x-amz-server-side-encryption-customer-key-MD5"},
        {"ObjectLockLegalHoldStatus", "x-amz-object-lock-legal-hold"},
        {"Tagging", "x-amz-tagging"},
        {"ExpectedBucketOwner", "x-amz-expected-bucket-owner"},
        {"WebsiteRedirectLocation", "x-amz-website-redirect-location"},
        {"ContentLanguage", "Content-Language"},
        {"SSECustomerAlgorithm", "x-amz-server-side-encryption-customer-algorithm"},
        {"ContentEncoding", "Content-Encoding"},
        {"ChecksumSHA256", "x-amz-checksum-sha256"},
        {"Expires", "Expires"},
        {"ContentMD5", "Content-MD5"},
        {"GrantWriteACP", "x-amz-grant-write-acp"},
        {"SSEKMSEncryptionContext", "x-amz-server-side-encryption-context"},
        {"CacheControl", "Cache-Control"},
        {"StorageClass", "x-amz-storage-class"},
        {"GrantRead", "x-amz-grant-read"},
        {"ContentLength", "Content-Length"},
        {"ObjectLockMode", "x-amz-object-lock-mode"},
        {"ContentDisposition", "Content-Disposition"},
        {"ServerSideEncryption", "x-amz-server-side-encryption"},
        {"SSEKMSKeyId", "x-amz-server-side-encryption-aws-kms-key-id"},
        {"GrantReadACP", "x-amz-grant-read-acp"},
        {"ChecksumCRC32", "x-amz-checksum-crc32"},
        {"ChecksumSHA1", "x-amz-checksum-sha1"}
      ]
      |> Request.build_params(input)

    query_params = []

    options =
      Keyword.put(
        options,
        :response_header_parameters,
        [
          {"x-amz-server-side-encryption-bucket-key-enabled", "BucketKeyEnabled"},
          {"x-amz-checksum-crc32", "ChecksumCRC32"},
          {"x-amz-checksum-crc32c", "ChecksumCRC32C"},
          {"x-amz-checksum-sha1", "ChecksumSHA1"},
          {"x-amz-checksum-sha256", "ChecksumSHA256"},
          {"ETag", "ETag"},
          {"x-amz-expiration", "Expiration"},
          {"x-amz-request-charged", "RequestCharged"},
          {"x-amz-server-side-encryption-customer-algorithm", "SSECustomerAlgorithm"},
          {"x-amz-server-side-encryption-customer-key-MD5", "SSECustomerKeyMD5"},
          {"x-amz-server-side-encryption-context", "SSEKMSEncryptionContext"},
          {"x-amz-server-side-encryption-aws-kms-key-id", "SSEKMSKeyId"},
          {"x-amz-server-side-encryption", "ServerSideEncryption"},
          {"x-amz-version-id", "VersionId"}
        ]
      )

    options =
      Keyword.put(
        options,
        :send_body_as_binary?,
        true
      )

    Request.request_rest(
      client,
      metadata(),
      :put,
      url_path,
      query_params,
      headers,
      input,
      options,
      nil
    )
  end
end
