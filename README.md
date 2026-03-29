## Prompt Attack PoC

Proof of Concept (PoC) that demonstrates a secure AI support workflow using Amazon Bedrock Agents and AgentCore (MCP) wrote in TypeScript. 

### Workflow:
  1. User: "Send a report to boss@truist.com."
  2. Agent: Recognizes the intent and triggers send_internal_report (Return of Control).
  3. Gateway: Intercepts the request and runs the Cedar Policy. 
  4. Cedar: Says "Success" (because it's a @truist.com email). 
  5. Lambda: Receives the payload, actually sends the report, and returns "200 OK". 
  6. Agent: Receives the "200 OK" and tells the user: "Report sent successfully!"

### Prerequisites:
* JDK/Node/Terraform
* Authenticated to AWS
  1. Logged into AWS account in browser
  2. `aws login`
  3. `export $(aws configure export-credentials --format env | xargs)`
* Submit Anthropic use case on Model Catalog section of Amazon Bedrock
* Contact AWS Support if your quota is 0 :D

### Structure:
```
PromptAttack/
├── AgentCore/            # [Terraform] Governance (Bedrock Guarrails + Cedar policies) And Enforcement (IAM and AgentCore Gateway)
│   ├── main.tf           
│   ├── policies/         # Cedar
│   └── providers.tf
│
├── Strands/              # [TypeScript] Orchestration
│   ├── src/              # @strands-agents/sdk
│   ├── package.json
│   └── tsconfig.json
│
├── Tools/                # [Java/Kotlin] Functional Execution (The "Muscle")
│   ├── src/              # Lambda tool handlers
│   ├── build.gradle.kts
│   └── schema.json       # OpenAPI spec for AgentCore integration
│
└── Payloads/             # [Data] Red-Team Test Cases
    ├── benign_ticket.txt
    └── malicious_injection.txt
```