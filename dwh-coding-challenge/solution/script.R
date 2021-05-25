library(dplyr)
library(lubridate)
library(rstudioapi)
library(stringr)
library(readxl)
library(Hmisc)
library(jsonlite)
library(plyr)

path <- "C:/Users/calvi/Downloads/dwh-coding-challenge.tar/dwh-coding-challenge/data/accounts" # GET FILE DIR ( FOLDER )

filenames_list <- list.files(path= path, full.names=TRUE) # CREATE LITS OF FILE IN THAT FOLDER 

customerData <- data.frame(id = as.factor(character()),
                           op = as.factor(character()),
                           ts = as.numeric(as.character()),
                           account_id = as.character(),
                           name = as.character(),
                           address = as.character(),
                           phone_number = as.character(),
                           email = as.character(),
                           savings_account_id = as.character(),
                           card_id = as.character()) # CREATE EMPTY DATA FRAME FOR PENADAH


for(i in 1:length(filenames_list)) {
  df <- as.data.frame(fromJSON(filenames_list[i])) %>%
    mutate(ts = as.character(ts))
  colnames(df) <- sub("data.", "", colnames(df))
  colnames(df) <- sub("set.", "", colnames(df))
  customerData <- rbind.fill(customerData,df)  %>%
    distinct(id,op,ts,.keep_all = T)
} # LOOPING INSERT DATA TO EMPTY DATA FRAME ABOVE 

customerDataFixed <- tidyr::fill(customerData, c(account_id,name,address,phone_number,email,savings_account_id,card_id))

as_tibble(customerDataFixed)


rm(df,filenames_list,i,path,customerData)



path <- "C:/Users/calvi/Downloads/dwh-coding-challenge.tar/dwh-coding-challenge/data/cards" # GET FILE DIR ( FOLDER )

filenames_list <- list.files(path= path, full.names=TRUE) # CREATE LITS OF FILE IN THAT FOLDER 

cardData <- data.frame(id = as.factor(character()),
                       op = as.factor(character()),
                       ts = as.numeric(as.character()),
                       card_id = as.character(),
                       card_number = as.character(),
                       credit_used = as.character(),
                       monthly_limit = as.character(),
                       status = as.character()) # CREATE EMPTY DATA FRAME FOR PENADAH


for(i in 1:length(filenames_list)) {
  df <- as.data.frame(fromJSON(filenames_list[i])) 
  colnames(df) <- sub("data.", "", colnames(df))
  colnames(df) <- sub("set.", "", colnames(df))
  df <- df %>%
    mutate(ts = as.character(ts))
  cardData <- rbind.fill(cardData,df)  %>%
    distinct(id,op,ts,.keep_all = T)
} # LOOPING INSERT DATA TO EMPTY DATA FRAME ABOVE 

cardDataFixed <- tidyr::fill(cardData, c(card_id,card_number,credit_used,monthly_limit,status))

as_tibble(cardDataFixed)


rm(df,filenames_list,i,path,cardData)



path <- "C:/Users/calvi/Downloads/dwh-coding-challenge.tar/dwh-coding-challenge/data/savings_accounts" # GET FILE DIR ( FOLDER )

filenames_list <- list.files(path= path, full.names=TRUE) # CREATE LITS OF FILE IN THAT FOLDER 

savingAccountData <- data.frame(id = as.factor(character()),
                                op = as.factor(character()),
                                ts = as.numeric(as.character()),
                                savings_account_id = as.character(),
                                balance = as.character(),
                                interest_rate_percent = as.character(),
                                status = as.character()) # CREATE EMPTY DATA FRAME FOR PENADAH


for(i in 1:length(filenames_list)) {
  df <- as.data.frame(fromJSON(filenames_list[i])) 
  colnames(df) <- sub("data.", "", colnames(df))
  colnames(df) <- sub("set.", "", colnames(df))
  df <- df %>%
    mutate(ts = as.character(ts))
  savingAccountData <- rbind.fill(savingAccountData,df)  %>%
    distinct(id,op,ts,.keep_all = T)
} # LOOPING INSERT DATA TO EMPTY DATA FRAME ABOVE 

savingAccountDataFixed <- tidyr::fill(savingAccountData, c(savings_account_id,balance,interest_rate_percent,status))

as_tibble(savingAccountDataFixed)


rm(df,filenames_list,i,path,savingAccountData)


finalResult <- customerDataFixed %>%
  full_join(savingAccountDataFixed, by = c("savings_account_id","ts","id","op")) %>%
  full_join(cardDataFixed, by = c("card_id","ts","id","op"))
