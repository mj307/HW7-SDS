library(plumber)
library(jsonlite)

model <- readRDS("model.rds")

prepare_input <- function(df) {
  library(lubridate)
  library(dplyr)

  df <- df %>%
    mutate(
      appt_time = ymd_hms(appt_time),
      appt_made = ymd(appt_made),
      diff_days = as.numeric(difftime(as.Date(appt_time), as.Date(appt_made), units = "days")),
      appt_hour = hour(appt_time),
      appt_wday = wday(appt_time, label = TRUE, week_start = 1)
    )

  # Ensure factor levels match the model's training data
  df$appt_wday <- factor(df$appt_wday,
                         levels = levels(model.frame(model)$appt_wday),
                         ordered = TRUE)

  return(df)
}





#* Predict Probabilities of no show
#* @post /predict_prob
#* @serializer json
predict_prob <- function(req, res){
  body <- jsonlite::fromJSON(req$postBody)
  data <- prepare_input(body)
  probs <- predict(model, newdata = data, type = "response")
  return(list(probabilities=as.numeric(probs)))
}

#* Predict binary no-show
#* @post /predict_class
#* @serializer json
predict_class <- function(req, res){
  body <- jsonlite::fromJSON(req$postBody)
  data <- prepare_input(body)
  probs <- predict(model, newdata = data, type = "response")
  class <- ifelse(probs >= 0.5, 1, 0)
  return(list(classes=as.integer(class)))
}

if (sys.nframe() == 0) {
  pr <- plumb("HW7_api_server.R")
  cat("Running plumber API at http://127.0.0.1:8000\n")
  cat("Docs at http://127.0.0.1:8000/__docs__/\n")
  pr$run(host = "127.0.0.1", port = 8000)
}
