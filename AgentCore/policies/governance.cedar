permit (
    principal,
    action == AgentCore::Action::"SupportTools___send_internal_report",
    resource is AgentCore::Gateway
)
when {
    context.input.recipient like "*@truist.com"
};