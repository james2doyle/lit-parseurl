parseurl
========

> Parse a URL with memoization.

This was modified from the node.js version at [pillarjs/parseurl](https://github.com/pillarjs/parseurl).

### Install

```sh
$ lit install james2doyle/parseurl
```

### Usage

```lua
local parseurl = require('parseurl')
```

parseurl.parseurl(req)

Parse the URL of the given request object (looks at the req.url property) and return the result. The result is the same as url.parse in Luvit core. Calling this function multiple times on the same req where req.url does not change will return a cached parsed object, rather than parsing again.

parseurl.original(req)

Parse the original URL of the given request object and return the result. This works by trying to parse req.originalUrl if it is a string, otherwise parses req.url. The result is the same as url.parse in Luvit core. Calling this function multiple times on the same req where req.originalUrl does not change will return a cached parsed object, rather than parsing again.