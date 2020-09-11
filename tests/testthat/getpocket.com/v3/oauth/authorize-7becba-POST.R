structure(list(
  url = "https://getpocket.com/v3/oauth/authorize",
  status_code = 403L, headers = structure(list(
    date = "Sun, 15 Mar 2020 11:05:30 GMT",
    `content-type` = "text/html; charset=UTF-8", `content-length` = "13",
    server = "Apache/2.4.25 (Debian)", `x-frame-options` = "SAMEORIGIN",
    `x-error` = "Invalid consumer key.", `x-error-code` = "152",
    status = "403 Forbidden", `cache-control` = "private",
    `x-source` = "Pocket", `set-cookie` = "REDACTED", p3p = "policyref=\"/w3c/p3p.xml\", CP=\"ALL CURa ADMa DEVa OUR IND UNI COM NAV INT STA PRE\""
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 403L, version = "HTTP/2",
    headers = structure(list(
      date = "Sun, 15 Mar 2020 11:05:30 GMT",
      `content-type` = "text/html; charset=UTF-8", `content-length` = "13",
      server = "Apache/2.4.25 (Debian)", `x-frame-options` = "SAMEORIGIN",
      `x-error` = "Invalid consumer key.", `x-error-code` = "152",
      status = "403 Forbidden", `cache-control` = "private",
      `x-source` = "Pocket", `set-cookie` = "REDACTED",
      p3p = "policyref=\"/w3c/p3p.xml\", CP=\"ALL CURa ADMa DEVa OUR IND UNI COM NAV INT STA PRE\""
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(domain = c(
    "#HttpOnly_getpocket.com",
    "#HttpOnly_getpocket.com"
  ), flag = c(FALSE, FALSE), path = c(
    "/",
    "/"
  ), secure = c(FALSE, FALSE), expiration = structure(c(
    Inf,
    1584273930
  ), class = c("POSIXct", "POSIXt")), name = c(
    "PHPSESSID",
    "AUTH_BEARER_default"
  ), value = c("REDACTED", "REDACTED")), row.names = c(
    NA,
    -2L
  ), class = "data.frame"), content = charToRaw("403 Forbidden"),
  date = structure(1584270330, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 0.019347,
    connect = 0.133203, pretransfer = 0.382742, starttransfer = 0.38282,
    total = 0.588804
  )
), class = "response")
