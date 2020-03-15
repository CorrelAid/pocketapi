structure(list(
    url = "https://getpocket.com/v3/oauth/request",
    status_code = 200L, headers = structure(list(
        date = "Sun, 15 Mar 2020 11:21:07 GMT",
        `content-type` = "application/x-www-form-urlencoded",
        `content-length` = "35", server = "Apache/2.4.25 (Debian)",
        `x-frame-options` = "SAMEORIGIN", status = "200 OK",
        `cache-control` = "private", `x-source` = "Pocket", `set-cookie` = "REDACTED",
        p3p = "policyref=\"/w3c/p3p.xml\", CP=\"ALL CURa ADMa DEVa OUR IND UNI COM NAV INT STA PRE\""
    ), class = c(
        "insensitive",
        "list"
    )), all_headers = list(list(
        status = 200L, version = "HTTP/2",
        headers = structure(list(
            date = "Sun, 15 Mar 2020 11:21:07 GMT",
            `content-type` = "application/x-www-form-urlencoded",
            `content-length` = "35", server = "Apache/2.4.25 (Debian)",
            `x-frame-options` = "SAMEORIGIN", status = "200 OK",
            `cache-control` = "private", `x-source` = "Pocket",
            `set-cookie` = "REDACTED", p3p = "policyref=\"/w3c/p3p.xml\", CP=\"ALL CURa ADMa DEVa OUR IND UNI COM NAV INT STA PRE\""
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
        1584274867
    ), class = c("POSIXct", "POSIXt")), name = c(
        "PHPSESSID",
        "AUTH_BEARER_default"
    ), value = c("REDACTED", "REDACTED")), row.names = c(
        NA,
        -2L
    ), class = "data.frame"), content = charToRaw("code=successrequesttokenyey"),
    date = structure(1584271267, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
        redirect = 0, namelookup = 0.019189,
        connect = 0.142407, pretransfer = 0.409698, starttransfer = 0.409801,
        total = 0.572897
    )
), class = "response")