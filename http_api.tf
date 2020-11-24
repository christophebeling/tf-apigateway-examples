resource "aws_lambda_permission" "lambda_permission" {
  statement_id = "AllowApiGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.helloWorldLambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_api" "api" {
  name = "hello-world-go"
  protocol_type = "HTTP"
  target = aws_lambda_function.helloWorldLambda.arn
}

resource "aws_apigatewayv2_route" "any" {
  api_id = aws_apigatewayv2_api.api.id
  route_key = "ANY /"
  authorization_type = "AWS_IAM"
}