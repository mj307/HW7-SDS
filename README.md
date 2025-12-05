# Homework7
Homework 7

To run the API:

library(plumber)

pr <- plumb("HW7_api_server.R")

pr$run(host="127.0.0.1", port=8000)


And to test the API, just run client_test.R in a separate R session (make sure the R session which is running the API is still running)
