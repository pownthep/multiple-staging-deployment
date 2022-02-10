resource "aws_api_gateway_rest_api" "rest_api" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.rest_api_name
      version = "1.0"
    }
    paths = {
      (var.rest_api_path) = {
        post = {
          x-amazon-apigateway-integration = {
            httpMethod            = "POST"
            integrationHttpMethod = "POST"
            passthroughBehavior   = "when_no_templates"
            payloadFormatVersion  = "1.0"
            type                  = "aws_proxy"
            uri                   = "arn:aws:apigateway:us-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-2:185877688501:function:example:$${stageVariables.version}/invocations"
          }
        }
      },
    }
  })

  name = var.rest_api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "lambda_permission_live" {
  action        = "lambda:InvokeFunction"
  function_name = "example"
  principal     = "apigateway.amazonaws.com"
  qualifier     = "live"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"
}
resource "aws_lambda_permission" "lambda_permission_staging" {
  action        = "lambda:InvokeFunction"
  function_name = "example"
  principal     = "apigateway.amazonaws.com"
  qualifier     = "staging"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"
}
resource "aws_lambda_permission" "lambda_permission_dev" {
  action        = "lambda:InvokeFunction"
  function_name = "example"
  principal     = "apigateway.amazonaws.com"
  qualifier     = "dev"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"
}
