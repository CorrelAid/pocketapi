library(testthat)
library(pocketapi)

POCKET_TEST_CONSUMER_KEY <- Sys.getenv("POCKET_TEST_CONSUMER_KEY")
POCKET_TEST_ACCESS_TOKEN <- Sys.getenv("POCKET_TEST_ACCESS_TOKEN")
test_check("pocketapi")
