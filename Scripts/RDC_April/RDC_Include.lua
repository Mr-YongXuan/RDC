RDC = RDC or {}

--[[
    Project: Rabbit DCS Cloud
    Version: April (alpha version)
    Component: 可复用方法 & 数据定义
    Copyright (C) 2021  LEO CAT
    License: GPL v3
    Sequence: 3
]]--


-- class define

RDC.SHP.Request = {
  -- request line
  Method   = "",
  Resource = "",
  Version  = "",

  --query arguments
  Arguments = {},

  -- request headers
  Headers = {},

  -- request body
  Body = ""
}


function RDC.SHP.Request:new()
  return self
end


RDC.SHP.Response = {
  -- response line
  Version = "",
  Status  = "",

  -- response headers
  Headers = {},

  -- response body
  Body = "",

  -- settings
  OnlyBodySentMode = false
}


function RDC.SHP.Response:new()
  RDC.SHP.Response.Version = "HTTP/1.1"
  RDC.SHP.Response.Status  = "200 OK"
  RDC.SHP.Response.Headers = {
    ["Content-Type"] = "text/html"
  }
  RDC.SHP.Response.Body = ""
  RDC.SHP.Response.OnlyBodySentMode = false
end


function RDC.SHP.Response:ReturnStatus_405()
  RDC.SHP.Response.OnlyBodySentMode = true
  RDC.SHP.Response.Body = RDC.SHP.HttpClientError_405()
end


function RDC.SHP.Response:ReturnStatus_404()
  RDC.SHP.Response.OnlyBodySentMode = true
  RDC.SHP.Response.Body = RDC.SHP.HttpClientError_404()
end


function RDC.SHP.Response:ReturnJson(data)
  RDC.SHP.Response.Headers["Content-Type"] = "application/json"
  RDC.SHP.Response.Body = RDC.JSON:encode(data)
end

RDC.info("RDC_Include.lua loaded!")