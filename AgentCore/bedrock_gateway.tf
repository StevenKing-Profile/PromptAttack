data "aws_caller_identity" "current" {}

resource "aws_bedrockagentcore_gateway" "support_gateway" {
  name            = "support-agent-gateway"
  protocol_type   = "MCP"
  authorizer_type = "AWS_IAM"
  role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SecurityPoC-Agent-Role"
  description     = "Description"
  exception_level = "DEBUG"

  interceptor_configuration {
    interception_points = ["REQUEST", "RESPONSE"]
    interceptor {
      lambda {
        arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:SupportTools-send-internal-report"
      }
    }
    input_configuration {
      pass_request_headers = false
    }
  }

  protocol_configuration {
    mcp {
      supported_versions = ["2025-03-26"]
    }
  }
}