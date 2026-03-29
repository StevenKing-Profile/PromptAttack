# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_guardrail
resource "aws_bedrock_guardrail" "support_guardrail" {
  name                      = "support-engineer-protection-v2"
  description               = "Blocks prompt injection in support tickets."
  blocked_input_messaging   = "SECURITY ALERT: Potential Prompt Injection detected."
  blocked_outputs_messaging = "Response blocked due to security violation."

  content_policy_config {
    filters_config {
      type            = "PROMPT_ATTACK"
      input_strength  = "HIGH"
      output_strength = "NONE"
    }
  }
}

resource "aws_bedrock_guardrail_version" "v1" {
  guardrail_arn  = aws_bedrock_guardrail.support_guardrail.guardrail_arn
  description   = "Initial security version"
}