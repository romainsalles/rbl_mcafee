require "rbl_mcafee/version"

module RblMcafee
  # Indicates a timeout checking an IP address
  class Timeout < TimeoutError; end

  # Indicates a failure to resolve an IP address
  class Error < StandardError; end;
end
