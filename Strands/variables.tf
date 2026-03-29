variable "gateway_url" {
  type        = string
  description = "The URL of the AgentCore Gateway where the MCP tools are hosted"
}

variable "agent_name" {
  type        = string
  default     = "support-governance-agent"
  description = "The name of the Bedrock Agent"
}

variable "region" {
  type        = string
  default     = "us-east-1"
}