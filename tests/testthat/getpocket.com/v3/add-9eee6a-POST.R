structure(list(
  url = "https://getpocket.com/v3/add", status_code = 403L,
  headers = structure(list(
    date = "Sat, 14 Mar 2020 12:17:58 GMT",
    `content-type` = "text/html; charset=UTF-8", `content-length` = "13",
    server = "Apache/2.4.25 (Debian)", `x-frame-options` = "SAMEORIGIN",
    `x-error` = "The provided keys do not have proper permission (e.g., add, modify, retrieve) to access requested API endpoint.",
    `x-error-code` = "151", status = "403 Forbidden", `x-source` = "Pocket",
    `set-cookie` = "REDACTED", p3p = "policyref=\"/w3c/p3p.xml\", CP=\"ALL CURa ADMa DEVa OUR IND UNI COM NAV INT STA PRE\""
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 403L, version = "HTTP/2",
    headers = structure(list(
      date = "Sat, 14 Mar 2020 12:17:58 GMT",
      `content-type` = "text/html; charset=UTF-8", `content-length` = "13",
      server = "Apache/2.4.25 (Debian)", `x-frame-options` = "SAMEORIGIN",
      `x-error` = "The provided keys do not have proper permission (e.g., add, modify, retrieve) to access requested API endpoint.",
      `x-error-code` = "151", status = "403 Forbidden",
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
    1584191878
  ), class = c("POSIXct", "POSIXt")), name = c(
    "PHPSESSID",
    "AUTH_BEARER_default"
  ), value = c("REDACTED", "REDACTED")), row.names = c(
    NA,
    -2L
  ), class = "data.frame"), content = charToRaw("403 Forbidden"),
  date = structure(1584188278, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 0.003693,
    connect = 0.127982, pretransfer = 0.389568, starttransfer = 0.389626,
    total = 0.63012
  )
), class = "response")
