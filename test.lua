local parseurl = require('./init').parseurl

local random = require('math').random

local function createReq(url, originalUrl)
  return {
    originalUrl = originalUrl or nil,
    url = url
  }
end

local function should_parse_the_request_URL ()
  local req = createReq('/foo/bar')
  local url = parseurl(req)
  assert(url.host == nil, true)
  assert(url.hostname == nil, true)
  assert(url.href, '/foo/bar')
  assert(url.pathname, '/foo/bar')
  assert(url.port == nil, true)
  assert(url.query == nil, true)
  assert(url.search == nil, true)
end

should_parse_the_request_URL()

local function should_parse_with_query_string ()
  local req = createReq('/foo/bar?fizz=buzz')
  local url = parseurl(req)
  assert(url.host == nil, true)
  assert(url.hostname == nil, true)
  assert(url.href, '/foo/bar?fizz=buzz')
  assert(url.pathname, '/foo/bar')
  assert(url.port == nil, true)
  assert(url.query, 'fizz=buzz')
  assert(url.search, '?fizz=buzz')
end

should_parse_with_query_string()

local function should_parse_a_full_URL ()
  local req = createReq('http://localhost:8888/foo/bar')
  local url = parseurl(req)
  assert(url.host, 'localhost:8888')
  assert(url.hostname, 'localhost')
  assert(url.href, 'http://localhost:8888/foo/bar')
  assert(url.pathname, '/foo/bar')
  assert(url.port, '8888')
  assert(url.query == nil, true)
  assert(url.search == nil, true)
end

should_parse_a_full_URL()

local function should_not_choke_on_auth_looking_URL ()
  local req = createReq('//todo@txt')
  assert(parseurl(req).pathname, '//todo@txt')
end

should_not_choke_on_auth_looking_URL()

local function should_return_nil_missing_url ()
  local req = createReq()
  local url = parseurl(req)
  assert(url == nil, true)
end

should_return_nil_missing_url()

local function should_parse_multiple_times_1 ()
  local req = createReq('/foo/bar')
  assert(parseurl(req).pathname, '/foo/bar')
  assert(parseurl(req).pathname, '/foo/bar')
  assert(parseurl(req).pathname, '/foo/bar')
end

should_parse_multiple_times_1()

local function should_reflect_url_changes ()
  local req = createReq('/foo/bar')
  local url = parseurl(req)
  local val = random()

  url._token = val
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')

  req.url = '/bar/baz'
  url = parseurl(req)
  assert(url._token == nil, true)
  assert(parseurl(req).pathname, '/bar/baz')
end

should_reflect_url_changes()

local function should_cache_parsing_1 ()
  local req = createReq('/foo/bar')
  local url = parseurl(req)
  local val = random()

  url._token = val
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')

  url = parseurl(req)
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')
end

should_cache_parsing_1()

local function should_cache_parsing_where_href_does_not_match_1 ()
  local req = createReq('/foo/bar ')
  local url = parseurl(req)
  local val = random()

  url._token = val
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')

  url = parseurl(req)
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')
end

should_cache_parsing_where_href_does_not_match_1()

-- testing the originalurl function --

local parseoriginal = require('./init').original

local function should_parse_the_request_original_URL ()
  local req = createReq('/foo/bar', '/foo/bar')
  local url = parseoriginal(req)
  assert(url.host == nil, true)
  assert(url.hostname == nil, true)
  assert(url.href, '/foo/bar')
  assert(url.pathname, '/foo/bar')
  assert(url.port == nil, true)
  assert(url.query == nil, true)
  assert(url.search == nil, true)
end

should_parse_the_request_original_URL()

local function should_parse_originalUrl_when_different ()
  local req = createReq('/bar', '/foo/bar')
  local url = parseoriginal(req)
  assert(url.host == nil, true)
  assert(url.hostname == nil, true)
  assert(url.href, '/foo/bar')
  assert(url.pathname, '/foo/bar')
  assert(url.port == nil, true)
  assert(url.query == nil, true)
  assert(url.search == nil, true)
end

should_parse_originalUrl_when_different()

local function should_parse_req_url_when_originalUrl_missing ()
  local req = createReq('/foo/bar')
  local url = parseoriginal(req)
  assert(url.host == nil, true)
  assert(url.hostname == nil, true)
  assert(url.href, '/foo/bar')
  assert(url.pathname, '/foo/bar')
  assert(url.port == nil, true)
  assert(url.query == nil, true)
  assert(url.search == nil, true)
end

should_parse_req_url_when_originalUrl_missing()

local function should_return_nil_missing_req_url_and_originalUrl ()
  local req = createReq()
  local url = parseoriginal(req)
  assert(url == nil, true)
end

should_return_nil_missing_req_url_and_originalUrl()

local function should_parse_multiple_times_2 ()
  local req = createReq('/foo/bar', '/foo/bar')
  assert(parseoriginal(req).pathname, '/foo/bar')
  assert(parseoriginal(req).pathname, '/foo/bar')
  assert(parseoriginal(req).pathname, '/foo/bar')
end

should_parse_multiple_times_2()

local function should_reflect_changes ()
  local req = createReq('/foo/bar', '/foo/bar')
  local url = parseoriginal(req)
  local val = random()

  url._token = val
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')

  req.originalUrl = '/bar/baz'
  url = parseoriginal(req)
  assert(url._token == nil, true)
  assert(parseoriginal(req).pathname, '/bar/baz')
end

should_reflect_changes()

local function should_cache_parsing_2 ()
  local req = createReq('/foo/bar', '/foo/bar')
  local url = parseoriginal(req)
  local val = random()

  url._token = val
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')

  url = parseoriginal(req)
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')
end

should_cache_parsing_2()

local function should_cache_parsing_if_req_url_changes ()
  local req = createReq('/foo/bar', '/foo/bar')
  local url = parseoriginal(req)
  local val = random()

  url._token = val
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')

  req.url = '/baz'
  url = parseoriginal(req)
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')
end

should_cache_parsing_if_req_url_changes()

local function should_cache_parsing_where_href_does_not_match_2 ()
  local req = createReq('/foo/bar ', '/foo/bar ')
  local url = parseoriginal(req)
  local val = random()

  url._token = val
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')

  url = parseoriginal(req)
  assert(url._token, val)
  assert(url.pathname, '/foo/bar')
end

should_cache_parsing_where_href_does_not_match_2()