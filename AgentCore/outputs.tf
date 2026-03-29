output "guardrail_id" {
  value = aws_bedrock_guardrail.support_guardrail.guardrail_id
}

output "guardrail_version" {
  value = aws_bedrock_guardrail_version.v1.version
}

output "agent_role_arn" {
  value = aws_iam_role.agent_execution_role.arn
}

output "gateway_url" {
  # The native resource attribute is gateway_url
  value       = aws_bedrockagentcore_gateway.support_gateway.gateway_url
}