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
  Version = "HTTP/1.1",
  Status  = "200 OK",

  -- response headers
  Headers = {
    ["Content-Type"] = "text/html"
  },

  -- response body
  Body = {},

  -- settings
  OnlyBodySentMode = false
}


function RDC.SHP.Response:new()
  return self
end


function RDC.SHP.Response:ReturnStatus_405()
  self.OnlyBodySentMode = true
  self.Body = RDC.SHP.HttpClientError_405()
end


function RDC.SHP.Response:ReturnStatus_404()
  self.OnlyBodySentMode = true
  self.Body = RDC.SHP.HttpClientError_404()
end


function RDC.SHP.Response:ReturnJson(data)
  self.Headers["Content-Type"] = "application/json"
  self.Body = RDC.JSON:encode(data)
end

RDC.info("RDC_Include.lua loaded!")