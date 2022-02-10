#
# Stage and Stage Settings
#

resource "aws_api_gateway_stage" "live_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "live"
  variables = {
    version = "live"
  }
}

resource "aws_api_gateway_method_settings" "live_gateway_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.live_gateway_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
  }
}
resource "aws_api_gateway_stage" "staging_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "staging"
  variables = {
    version = "staging"
  }
}

resource "aws_api_gateway_method_settings" "staging_gateway_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.staging_gateway_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
  }
}

resource "aws_api_gateway_stage" "dev_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"
  variables = {
    version = "dev"
  }
}

resource "aws_api_gateway_method_settings" "dev_gateway_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.dev_gateway_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
  }
}
