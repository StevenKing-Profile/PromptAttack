# AI Agent/Strands Code
resource "aws_iam_user" "agent_dev" {
  name = "AgentDev"
}

resource "aws_iam_role" "agent_execution_role" {
  name = "SecurityPoC-Agent-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = [
          "bedrock.amazonaws.com",
          "bedrock-agentcore.amazonaws.com"
        ]
      }
    }]
  })
}

resource "aws_iam_role_policy" "agent_permissions" {
  name = "Agent-Permissions-Policy"
  role = aws_iam_role.agent_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["bedrock:InvokeModel", "lambda:InvokeFunction"]
        Resource = "*" # TODO: Scope this to specific Lambdas
      }
    ]
  })
}

resource "aws_iam_role_policy" "policy_engine_bridge" {
  name = "AgentCore-Policy-Bridge"
  role = aws_iam_role.agent_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:GetPolicyEngine",
          "bedrock-agentcore:GetPolicy",
          "bedrock-agentcore:AuthorizeAction",
          "bedrock-agentcore:PartiallyAuthorizeActions",
          "bedrock-agentcore:GetGateway"
        ]
        Resource = "*"
      }
    ]
  })
}