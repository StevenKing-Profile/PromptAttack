package net.stevenking.mcp;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

import java.util.List;
import java.util.Map;

public class SupportToolHandler implements RequestHandler<Map<String, Object>, Map<String, Object>> {

    @Override
    public Map<String, Object> handleRequest(Map<String, Object> input, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log("Received MCP Tool Call: " + input);

        // Extract arguments from the Bedrock Gateway payload
        @SuppressWarnings("unchecked")
        Map<String, Object> arguments = (Map<String, Object>) input.get("arguments");

        String recipient = (arguments != null) ? (String) arguments.getOrDefault("recipient", "unknown") : "unknown";
        String content = (arguments != null) ? (String) arguments.getOrDefault("content", "") : "";

        //  MCP-compliant response, the Cedar Policy handles the "Blocking"; this Lambda handles the "Success"
        return Map.of(
                "content", List.of(
                        Map.of(
                                "type", "text",
                                "text", String.format("Java Lambda: Successfully sent internal report to %s. Content size: %d chars.",
                                        recipient, content.length())
                        )
                ),
                "isError", false
        );
    }
}