`pocketapi`
================

[![Travis build status](https://travis-ci.org/CorrelAid/pocketapi.svg?branch=master)](https://travis-ci.org/CorrelAid/pocketapi)

This is a R wrapper for the [Pocket](https://getpocket.com) API. You can use `pocketapi` to access and modify your *own* pockets and to add new links to your Pocket programmatically. 

# Installation

## Current Development Version

This package is currently only available on GitHub. You can install it using `devtools`. 

``` r
# install devtools package if it's not already
install.packages("devtools")

# install package from GitHub
devtools::install_github("correlaid/pocketapi")

# load package
library(pocketapi)
```


# Get started

## Authentication

### Create a Pocket Application
You need to create a Pocket *application* in the Pocket developer portal to access your Pocket data. Don't worry: this app will only be visible to you and only serves the purpose of acquiring the credentials for `pocketapi`. 

1. Log in to your Pocket account and go to [https://getpocket.com/developer/apps/new](https://getpocket.com/developer/apps/new).
2. Click "Create New Application". You'll be presented with a form. Choose a sensible application *name* and a *description*.
3. Give your app *permissions*: Depending on the permissions of your app, you'll be able to use all or a subset of the `pocketapi` functions:

| `pocketapi` function | what it does                       | needed permission |
| -------------------- | ---------------------------------- | ----------------- |
| `pocket_get`         | get data frame of all your pockets | Retrieve          |
| `pocket_add`         | add URL(s) to your Pocket          | Add               |
| `pocket_edit`        | edit existing Pocket entries       | Modify            |

4. Check any *platform* for your app - this does not really matter but you need to check at least one box. 
5. Accept the *terms of service* and click "Create Application".

### Get consumer key and token
It is common practice to set API keys in your R environment file. Hence, every time you start R the key is loaded. The functions `get_headlines`, `get_headlines_all`, `get_everything`, `get_everything_all`, and `get_sources` access your key automatically by executing `Sys.getenv("NEWS_API_KEY")`. Alternatively, you can provide an explicit definition of your api\_key with each function call.

In order to add your key to your environment file, you can use the function `edit_r_environ` from the `usethis` package.

This will open your `.Renviron` file in your text editor. Now, you can add the following line to it:

    NEWS_API_KEY="yourkeygoeshere"

Save the file and restart R for the changes to take effect.

If your `.Renviron` lives at a non-conventional place, you can also use the function `set_api_key` from the `newsanchor` package to add the API key to your environment file. The function below appends the key automatically to your R environment file. You will be prompted to enter your API key into a popup box.

