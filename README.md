# pocketapi

<!-- badges: start -->

[![R build status](https://github.com/CorrelAid/pocketapi/workflows/R-CMD-check/badge.svg)](https://github.com/CorrelAid/pocketapi/actions)
[![Codecov test coverage](https://codecov.io/gh/CorrelAid/pocketapi/branch/master/graph/badge.svg)](https://codecov.io/gh/CorrelAid/pocketapi?branch=master)
[![CRAN status](https://www.r-pkg.org/badges/version/pocketapi)](https://CRAN.R-project.org/package=pocketapi)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

<!-- badges: end -->

This is a R wrapper for the [Pocket API](https://getpocket.com/developer/docs/overview). You can use `pocketapi` to access and modify your _own_ pockets and to add new links to your Pocket programmatically.

Functions include:

- `pocket_add()`
- `pocket_get()`
- `pocket_archive()`
- `pocket_delete()`
- `pocket_favorite()`
- `pocket_unfavorite()`
- `pocket_tag()`

# Installation

## CRAN Version

```r
# install via CRAN
install.packages("pocketapi")
```

## Current Development Version

You can install the latest development version using `devtools`.

```r
# install devtools package if it's not already
install.packages("devtools")

# install package from GitHub
devtools::install_github("correlaid/pocketapi")

# load package
library(pocketapi)
```

# Get Started

## Authentication

### Create a Pocket Application

You need to create a Pocket _application_ in the Pocket developer portal to access your Pocket data. Don't worry: this app will only be visible to you and only serves the purpose of acquiring the credentials for `pocketapi`.

1. Log in to your Pocket account and go to [https://getpocket.com/developer/apps/new](https://getpocket.com/developer/apps/new).
2. Click "Create New Application". You'll be presented with a form. Choose a sensible application _name_ and a _description_.
3. Give your app _permissions_: Depending on the permissions of your app, you'll be able to use all or a subset of the `pocketapi` functions:

| `pocketapi` function           | what it does                       | needed permission |
| ------------------------------ | ---------------------------------- | ----------------- |
| `pocket_get`                   | get data frame of all your pockets | Retrieve          |
| all other `pocket_*` functions | add new Pocket entries             | Modify            |

4. Check any _platform_ for your app - this does not really matter but you need to check at least one box.
5. Accept the _terms of service_ and click "Create Application".

### Get consumer key and token

`pocketapi` uses the OAuth2 flow provided by the [Pocket Authentication API](https://getpocket.com/developer/docs/authentication) to get an access token for your App. Because Pocket does not closely follow the OAuth standard, we could not provide as smooth an experience as other packages do (e.g. [googlesheets4](https://github.com/tidyverse/googlesheets4)). Instead, the user has to do the following **once** to obtain an access token:

1. Request a request token.
```
request_token <- get_request_token(consumer_key)
```

2. Authorize your app by entering the URL created by `create_authorize_url` **in your browser**:

```r
create_authorize_url(request_token)
```

:warning: This step is critical: **Even if you have authorized your app before** and you want to get a new access token, you need to do the authorization in your browser again. Otherwise, the request token will not be authorized to generate an access token!

3. Get access token using the now authorized request token

```r
access_token <- get_access_token(consumer_key, request_token)
```

You can now already use the package by specifying the consumer key and access token manually as arguments to each function call: 

```
pocketapi::pocket_get(consumer_key = consumer_key, access_token = access_token)
```

To make it easier to work with the package, you should set them as environment variables. 

### Add the consumer key and access token to your environment

**Important**: Never make your `consumer_key` and `access_token` publicly available - anyone will be able to access your Pockets!

It is common practice to set API keys in your R environment file so that every time you start R the key is loaded.

All `pocketapi` functions access your `consumer_key` and `access_token` automatically by executing `Sys.getenv("POCKET_CONSUMER_KEY")` respectively `Sys.getenv("POCKET_ACCESS_TOKEN")` . Alternatively, you can provide an explicit definition of your `consumer_key` and `access_token` with each function call.

In order to add your key to your environment file, you can use the function `edit_r_environ` from the `usethis` package:

```r
usethis::edit_r_environ()
```

This will open your `.Renviron` file in the RStudio editor. Now, you can add the following lines to it:

```
POCKET_CONSUMER_KEY="yourkeygoeshere"
POCKET_ACCESS_TOKEN="youraccesstokengoeshere"
```

Save the file and restart R for the changes to take effect.

If your `.Renviron` lives at a non-conventional place, you can also edit it manually using RStudio or your favorite text editor.

If you don't want to clutter the `.Renviron` file in your home folder, you can also use a local `.Renviron` file in your project folder and read it in using the `readRenviron()` function. In this case, make sure to never share your local `.Renviron` file.

## Get, modify, and add Pockets

Check out the vignette to see in more detail how to add, get, and modify your Pockets using those functions.

```r
library(pocketapi)
vignette("pocketapi")
```

# Limitations

This package has some limitations:

- You can only modify your own Pockets.
- The Pocket API does not follow REST API standards and exhibits some weird behaviours. For example, even if a `modify` action is not successful, the API will still return "success". See [issue [#26](https://github.com/CorrelAid/pocketapi/issues/26) for a discussion of weird behaviours of the API.

# Contribute

Contributions to this package are welcome. Please see `CONTRIBUTING.md`.
