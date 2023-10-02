####   ########   Question - PEOPLE WITH A POOR HEALTH (GENERAL HEALTH STATUS)
## To set the working directory
setwd("C:/Users/DEBBIE/Music/RSTUDIO/Business inteligence/BI INDI ASS")
setwd("C:/Users/Abiodun Ojebiyi/Downloads")

## Libraries which would be used for the analysis
library(readxl)  
library(ggplot2)
library(dplyr)   
library(skimr)
library(broom)  
library(margins)
library(stargazer)  
library(rpart)    #for decision trees
library(rattle)   #to visualize decision trees
library(caret) 
library(haven)
library(gridExtra)#to read dta. file

### Call the necessary dataset #####
health2 <- read_dta("eqls_2007.dta")
skim(health2)

#############============= DATA RESTRICTIONS ======== ###################
######## SELECTION OF THE VARIABLES TO BE USED FOR THE ANALYSIS
phealth <- health2 %>% select(Y11_Q42, Y11_Q43, Y11_Q44, Y11_EmploymentStatus, Y11_Q53a, Y11_Q31, Y11_Q49, Y11_Q19b, Y11_Q19c, Y11_Q40f, Y11_Q47a, Y11_Q47c, Y11_Q47d)

###############DESCRIPTIVE STATISTICS###############
skim(phealth)
summary(phealth)

table(phealth$Y11_Q42) #, useNA = "ifany") #64 missing values
table(phealth$Y11_Q43) #, useNA = "ifany") #486 missing values
table(phealth$Y11_Q44) #, useNA = "ifany") #25751 missing values
table(phealth$Y11_EmploymentStatus)   #, useNA = "ifany") 
table(phealth$Y11_Q53a) # , useNA = "ifany") #626 missing values
table(phealth$Y11_Q19b)   #, useNA = "ifany") #129 missing values
table(phealth$Y11_Q19c)   #, useNA = "ifany") #118 missing values
table(phealth$Y11_Q40f)   #, useNA = "ifany") #329 missing values
table(phealth$Y11_Q47a)  #, useNA = "ifany") #2399 missing values
table(phealth$Y11_Q47c)  #, useNA = "ifany") #2670 missing values
table(phealth$Y11_Q47d) #, useNA = "ifany") #3739 missing values

############################# DATA TRANSFORMATIONS #######################

# This creates a new variable called 'genhealth' by changing the Y11_Q42, 
# 'illness' - Y11_Q43, 'limitedmob' - Y11_Q44, 
phealth <- phealth %>% rename(genhealth = Y11_Q42)
phealth <- phealth %>% filter(!is.na(Y11_Q43)) %>% rename(illness = Y11_Q43) 

#the datacode book says that all "no" in Q43 should skip. and all yes should respond to Q44 Hence, Q44 is a filter question for Q43, meaning we know the value for the missings even a respondent has not answered the question. creating a new variable called 'limitedmob' 

phealth <- phealth %>% rename(limitedmob = Y11_Q44) %>% mutate(limitedmob = case_when(limitedmob == 1 ~ 1, limitedmob == 2 ~ 2, TRUE ~ 3))
phealth <- phealth %>% rename(healthquality = Y11_Q53a) %>% filter(healthquality > 0)
phealth <- phealth %>% rename(employedstats = Y11_EmploymentStatus)
phealth <- phealth %>% rename(accomodation_rot = Y11_Q19b) %>% filter(accomodation_rot > 0)
phealth <- phealth %>% rename(accomodation_leak = Y11_Q19c) %>% filter(accomodation_leak > 0) 
phealth <- phealth %>% rename(health_sats = Y11_Q40f) %>% filter(health_sats > 0) 
phealth <- phealth %>% rename(distance_doc = Y11_Q47a) %>% filter(distance_doc > 0) 
phealth <- phealth %>% rename(wait_time = Y11_Q47c) %>% filter(wait_time > 0) 
phealth <- phealth %>% rename(cost_doc = Y11_Q47d) %>% filter(cost_doc > 0)





############# ================ SELECTING VARIABLES FOR ANALAYSIS ======#########################

health <- phealth %>% select(genhealth, healthquality, illness, limitedmob, cost_doc, employedstats, accomodation_leak, accomodation_rot, distance_doc, wait_time, health_sats, genhealth)

healthvis <- health %>% select(genhealth, healthquality, illness, limitedmob, cost_doc, employedstats, accomodation_leak, accomodation_rot, distance_doc, wait_time, health_sats, genhealth)
healthvis <- healthvis[complete.cases(healthvis), ]

skim(health)
health <- health %>% mutate(genhealthbin = ifelse(health$genhealth %in% c(1, 2, 3), 0, ifelse(health$genhealth %in% c(4, 5), 1, health$genhealth)))

health <- health[complete.cases(health), ]
#health <- health %>% mutate(genhealth = ifelse(genhealth %in% c(1, 2, 3), "good",
# ifelse(genhealth %in% c(4, 5), "bad", genhealth)))

health <- health %>% mutate(illness = ifelse(illness == 1,1,0))
health <- health %>% mutate(limitedmob = ifelse(limitedmob %in% c(1, 2), 1, 0))
health <- health %>% mutate(accomodation_rot = case_when(accomodation_rot == 1 ~ "yes", accomodation_rot == 2 ~ "no"))
health <- health %>% mutate(accomodation_rot = ifelse(accomodation_rot == "yes",1,0))
health <- health %>% mutate(accomodation_leak = case_when(accomodation_leak == 1 ~ "yes", accomodation_leak == 2 ~ "no"))
health <- health %>% mutate(accomodation_leak = ifelse(accomodation_leak == "yes",1,0))
health <- health %>% mutate(health_sats = case_when(health_sats >= 1 & health_sats <= 4 ~ "dissatisfied", health_sats >= 5 & health_sats <= 10 ~ "satisfied")) %>% mutate(health_sats = ifelse(health_sats == "dissatisfied",1,0))
health <- health %>% mutate(distance_doc = case_when(distance_doc == 1 ~ "verydifficult", distance_doc == 2 ~ "alildifficult", distance_doc == 3 ~ "notdifficult")) %>% mutate(distance_doc = ifelse(distance_doc == "verydifficult" | distance_doc == "alildifficult",1,0))
health <- health %>% mutate(wait_time = case_when(wait_time == 1 ~ "verydifficult", wait_time == 2 ~ "alildifficult", wait_time == 3 ~ "notdifficult")) %>% mutate(wait_time = ifelse(wait_time == "verydifficult" | wait_time == "alildifficult",1,0))
health <- health %>% mutate(cost_doc = case_when(cost_doc == 1 ~ "verydifficult", cost_doc == 2 ~ "alildifficult", cost_doc == 3 ~ "notdifficult")) %>% mutate(cost_doc = ifelse(cost_doc == "verydifficult" | cost_doc == "alildifficult",1,0))

# data selection, filter and variable transformation, selecting a variable to serve as a unique identifier
health <- health %>% mutate(healthqualitysq = healthquality * healthquality, cid = row_number())
table(health$healthquality, useNA = "ifany")


#nominal variables, use as factors
health$genhealthbin <- as.integer(health$genhealthbin)
health$healthquality <- as.integer(health$healthquality)
health$healthqualitysq <- as.integer(health$healthqualitysq)




skim(health)

# 1. data split
set.seed(3)
train <- health %>% sample_frac(0.80)
test  <- anti_join(health, train, by = "cid")

# 2. descriptive stats
skim(train)
skim(test)

# 3. fit the model
reg <- lm(data = train, genhealth ~ limitedmob + cost_doc + health_sats + illness + employedstats + accomodation_rot + accomodation_leak + distance_doc + wait_time + healthquality + healthqualitysq)
summary(reg)


# 4. interpret the model21` 1`

# 5. plot
train <- augment(reg, train)
ggplot(data = train) + geom_point(aes(y = .fitted, x = health_sats), alpha = 0.1) + geom_point(aes(y = genhealth, x = health_sats), alpha = 0.1, color = "red") +
  theme_minimal()


# 6. prediction
test <- augment(reg, newdata = test)
# the residual is the difference between customer_satisfaction and the .fitted which is the estimated
#   customer satisfaction. The mean of the residuals is zero by definition (assumption of OLS) but the 
#   square of the residuals are positive. 
test %>% summarise(RMSE = sqrt(mean(.resid^2)))
train %>% summarise(RMSE = sqrt(mean(.resid^2)))

# 7. new draw
train2 <- health %>% sample_frac(0.80)
test2  <- anti_join(health, train2, by = "cid")
reg2 <- lm(data = train2, genhealth ~ limitedmob + cost_doc + health_sats + illness + employedstats + accomodation_rot + accomodation_leak + distance_doc + wait_time + healthquality + healthqualitysq)
summary(reg2)
 
train2 <- augment(reg2, train2)         
test2 <- augment(reg2, newdata = test2)
test2 %>% summarise(RMSE = sqrt(mean(.resid^2)))
train2 %>% summarise(RMSE = sqrt(mean(.resid^2)))



#############VISUALIZATION##########
# Create a color palette with shades of blue
colors <- colorRampPalette(c("lightblue", "darkblue"))(length(unique(healthvis$genhealth)))

# Labels for factor(genhealth)
genhealth_labels <- c("1" = "Very Good", "2" = "Good", "3" = "Fair", "4" = "Bad", "5" = "Very Bad")



# Plot the proportion plot

Figure1 <- ggplot(data = healthvis, aes(x = factor(genhealth), fill = factor(genhealth))) + geom_histogram(stat = "count") + scale_fill_manual(values = colors, labels = genhealth_labels) + labs(title = "General Health", x = "General Health") + theme_minimal() + theme(plot.title = element_text(hjust = 0.5, size = 18), axis.text = element_text(size = 12), axis.title = element_text(size = 14))



Figure2 <- ggplot(data = healthvis, aes(x = factor(limitedmob), fill = factor(genhealth))) + geom_bar() + scale_fill_manual(values = colors, labels = genhealth_labels) + labs(title = "General Health Proportion Plot vs Limited Mobility", x = "Limited Mobility", y = "Proportion") + scale_x_discrete(labels = c("1" = "Yes", "2" = "To Some Extent", "3" = "No")) + theme_minimal() + theme(plot.title = element_text(hjust = 0.5, size = 18), axis.text = element_text(size = 12), axis.title = element_text(size = 14))



Figure3 <- ggplot(data = healthvis, aes(x = factor(cost_doc), fill = factor(genhealth))) + geom_bar(position = "fill", color = "skyblue") + scale_fill_manual(values = colors, labels = genhealth_labels) + labs(title = "General Health Proportion Plot vs cost", x = "Limited Mobility", y = "Proportion") + scale_x_discrete(labels = c("1" = "very difficult", "2" = "a little difficult", "3" = "Not difficult")) + theme_minimal() + theme(plot.title = element_text(hjust = 0.5, size = 18), axis.text = element_text(size = 12), axis.title = element_text(size = 14))

Figure4 <- ggplot(data = healthvis, aes(x = factor(accomodation_leak), fill = factor(genhealth))) + geom_bar(position = "fill", color = "skyblue") + scale_fill_manual(values = colors, labels = genhealth_labels) + labs(title = "General Health Proportion Plot vs Leakage in Accomodation", x = "Limited Mobility", y = "Proportion") + scale_x_discrete(labels = c("1" = "Yes", "2" = "No")) + theme_minimal() + theme(plot.title = element_text(hjust = 0.5, size = 18), axis.text = element_text(size = 12), axis.title = element_text(size = 14))

#Create Dashboard
grid.arrange(Figure1,Figure2,Figure3,Figure4)


###############DATA PREPARATION FOR LOGIT MODEL
# outcome variable; Ratings of health quality

myformula <- formula(genhealthbin ~ limitedmob + cost_doc + health_sats + illness + employedstats + accomodation_rot + accomodation_leak + distance_doc + wait_time + healthquality + healthqualitysq)


logit <- glm(data = train, myformula, family = binomial(link = "logit"))
summary(logit)

# 3. calculate marginal effects

# get marginal effects with the margins() function
logit_marginal <- margins(logit)
summary(logit_marginal)


# 4. interpretation

# 5. accuracy
# for logit models, you need to specify the prediction because the default produces log-odds
# specify "link" to get the xb with 1/(1+exp(-xb)) = response
logit_pred <- augment(logit, type.predict = "response", newdata = test2)
summary(logit_pred$.fitted)
# create dummy variable
logit_pred <- logit_pred %>% mutate(pred_genhealthbin_logit = ifelse(.fitted > 0.5,"verygood","verybad"))
# truth table
table(logit_pred$pred_genhealthbin_logit, logit_pred$genhealthbin, useNA = "ifany")
# accuracy: (5114+484)/6032 = 92.80%



#### analysis

lm <- lm(data = train, formula = myformula)
logit <- glm(data = train, formula = myformula, family = binomial(link = "logit"))
stargazer(lm, logit, type = "text")

# accuracy logit, using the library(InformationValue)
pred_logit <- predict(logit, type = "response", newdata = test)
confusionMatrix(test$genhealthbin, pred_logit)
optimal <- optimalCutoff(test$genhealthbin, pred_logit)
confusionMatrix(test$genhealthbin, pred_logit, threshold = optimal)
plotROC(test$genhealthbin, pred_logit)



