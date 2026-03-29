# Lambda
resource "aws_lambda_function" "mcp_support" {
  function_name    = "mcp-support"
  role             = aws_iam_role.lambda_mcp_role.arn
  handler          = "net.stevenking.mcp.SupportToolHandler::handleRequest"
  runtime          = "java21"
  filename         = "${path.module}/target/mcp-tools-1.0.0.jar"
  source_code_hash = filebase64sha256("${path.module}/target/mcp-tools-1.0.0.jar")
  memory_size      = 512
  timeout          = 30
}

# CloudWatch/Log Groups
resource "aws_cloudwatch_log_group" "lambda_mcp_logs" {
  name              = "/aws/lambda/mcp-support"
  retention_in_days = 5
}

# IAM
resource "aws_iam_role" "lambda_mcp_role" {
  name = "lambda-mcp-java-target-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_mcp_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Ensure the IAM role has the permissions to write to it
resource "aws_iam_role_policy" "lambda_mcp_logging_policy" {
  name = "lambda-mcp-logging-policy"
  role = aws_iam_role.lambda_mcp_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}
