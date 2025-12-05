## Write your client test code here
library(httr)
library(jsonlite)
library(tidyverse)

#----------------------------
# Load sample/test data
#----------------------------
test_data <- read_csv("test_dataset.csv.gz") %>%
  head(5) %>%
  select(provider_id, address, specialty, age, appt_time, appt_made)

#----------------------------
# Convert to raw JSON string (no encode option!)
#----------------------------
json_input <- toJSON(test_data, dataframe = "rows")

#----------------------------
# Base API URL
#----------------------------
base_url <- "http://127.0.0.1:8000/"

#----------------------------
# Call predict_prob endpoint (NO encode="json")
#----------------------------
res_prob <- POST(
  url = paste0(base_url, "predict_prob"),
  body = json_input,
  content_type_json()
)

probabilities <- fromJSON(content(res_prob, "text"))
print(probabilities)

#----------------------------
# Call predict_class endpoint
#----------------------------
res_class <- POST(
  url = paste0(base_url, "predict_class"),
  body = json_input,
  content_type_json()
)

classes <- fromJSON(content(res_class, "text"))
print(classes)

