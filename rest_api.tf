resource "aws_api_gateway_rest_api" "api" {
  name = "hello-world-go-rest"
}

resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "api" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [aws_api_gateway_integration.api]
  rest_api_id = aws_api_gateway_rest_api.api.id

  stage_name = "test"
}

resource "aws_api_gateway_integration" "api" {
  http_method = aws_api_gateway_method.api.http_method
  integration_http_method = "POST"
  resource_id = aws_api_gateway_resource.api.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  type = "AWS_PROXY"
  uri = aws_lambda_function.helloWorldLambda.invoke_arn
}

resource "aws_lambda_permission" "lambda_permission_rest" {
  statement_id = "AllowApiGatewayInvokeREST"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.helloWorldLambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
