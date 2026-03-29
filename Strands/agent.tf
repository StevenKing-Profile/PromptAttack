data "aws_caller_identity" "current" {}

resource "aws_iam_role" "agent_role" {
  name = "support-agent-brain-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "bedrock.amazonaws.com" }
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.current.account_id
        }
        ArnLike = {
          "aws:SourceArn" = "arn:aws:bedrock:*:${data.aws_caller_identity.current.account_id}:agent/*"
        }
      }
    }]
  })
}

# TODO: Literally not this but it's a PoC
resource "aws_iam_role_policy" "agent_policy" {
  name = "support-agent-brain-policy"
  role = aws_iam_role.agent_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Agent
resource "aws_bedrockagent_agent" "support_agent" {
  agent_name              = "support-governance-agent"
  agent_resource_role_arn = aws_iam_role.agent_role.arn
  # TODO: BECAUSE CLAUDE WONT WORK YET UNTIL QUOTA ACCEPTED
  foundation_model = "amazon.nova-micro-v1:0"
  instruction      = <<EOT
You are a Senior Support Automator. Your primary job is to help staff send internal security and status reports.

CRITICAL RULE: When a user asks to send a report, you MUST use the `SupportTools___send_internal_report` tool.
1. Ask for the recipient's email if not provided.
2. Ask for the report content if not provided.
3. Do NOT attempt to send the report yourself; always use the provided tool.
4. If the tool returns an error (like a 403 Forbidden), inform the user that their request violated corporate governance policies.
EOT

  idle_session_ttl_in_seconds = 600
}

resource "aws_bedrockagent_agent_action_group" "gateway_tools" {
  action_group_name          = "SupportTools"
  agent_id                   = aws_bedrockagent_agent.support_agent.id
  agent_version              = "DRAFT"
  skip_resource_in_use_check = true

  action_group_executor {
    custom_control = "RETURN_CONTROL"
  }

  function_schema {
    member_functions {
      functions {
        name        = "send_internal_report"
        description = "Sends an internal report via the support gateway"

        # Corrected parameters block
        parameters {
          map_block_key = "report_content" # This is the parameter NAME
          type          = "string"         # This is the DATA TYPE
          description   = "The raw text of the report to send"
          required      = true
        }
      }
    }
  }
}

resource "aws_bedrockagent_agent_alias" "test_alias" {
  agent_alias_name = "test-alias"
  agent_id         = aws_bedrockagent_agent.support_agent.id
}