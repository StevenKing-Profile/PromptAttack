module "java_tools" {
  source = "./Tools"
}

module "agentcore" {
  source                = "./AgentCore"
  mcp_target_lambda_arn = module.java_tools.mcp-support_arn
}

module "strands" {
  source      = "./Strands"
  gateway_url = module.agentcore.gateway_url
}