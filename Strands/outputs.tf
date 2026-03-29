output "agent_id" {
  value       = aws_bedrockagent_agent.support_agent.id
  description = "The unique identifier for the Bedrock Agent"
}

output "agent_alias_id" {
  value       = aws_bedrockagent_agent_alias.test_alias.agent_alias_id
  description = "The ID of the Agent Alias created for testing"
}

output "agent_role_arn" {
  value       = aws_iam_role.agent_role.arn
  description = "The IAM Role ARN the Agent is using"
}