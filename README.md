# R


EXECUTIVE SUMMARY 

Using data from the 2007 European Quality of Life Survey, the report focuses on people's overall health and seeks to discover underlying problems that cause poor health. The paper offers important insights by examining mental health, living situations, and many aspects affecting health. It is important to note that  from the analysis, respondents who have a chronic disease or impairment are more likely to be in poor overall health, higher healthcare cost has the is correlated to poor health. The analysis was able to establish that a different number of factors one of which is leakage in their accommodation can affect poor health and the general health status of a person. One of the main recommendations is to increase doctor availability and decrease wait times for healthcare services, lower the cost of healthcare and aid assistance to those who lack mobility as a result. Companies, business groups, the parliament, government officials may proactively address the challenges identified and encourage improved health by taking into consideration these factors to improve general health 

INTRODUCTION
The general health status of individuals in general is an important measure that reflects their overall well-being and quality of life; it provides a comprehensive look into their mental, social and physical well-being. This report makes use of the European Quality of Life Survey 2007 dataset, to access the poor health of individuals in a general health state, and develop models that highlight underlining issues that may result in a bad health for most individuals. Taking a deeper look into the mental well-being and living conditions of individuals. Rstudio will be used to prepare the data and carry out the statistical analysis. Based on the findings, the report will provide intelligence on the problems looking at a bad health and offer recommendations, strategies and possible further investigations needed to be carried out to improve the situation/problem identified. 

A multiple regression was carried out to determine the linearity between the dependent variable (genhealth with illness) and selected related explanatory variables. Using a logit model to examine the connection between these variables and the dependent variable. The goal of the model chosen is to estimate the values of the parameters β that best fit the observed data and minimize the sum of squared residuals which is done using least squares methods. The model summary provides information about the estimated coefficients, p-values, as well as measures of the model's performance in appendix 3. The prediction models’ interpretations are as follows; 
First, it is important to have a look at the distribution of the respondents with fair/bad, as regards their general health status. According to graph 1 below, a good number of the respondents selected that their heath was indeed not good. 
Graph 1:
 
Genhealth and Illness: 
In analysing the bad health of respondents as regards their general health, in graph 2 below, a low number of respondents classified their health as bad and majority classified their health as either fair or good. We look at the proportion of General health


 Of respondents paired with Illness (respondents with chronic illness or disability or mental health problems). 
 
In holding all variables constant at 1.25, a unit increase in illness is associated by a 6.68%, increase is more likely to have a bad health in general. The lower p-value (<0.0001) in the model also shows that this factor is significant for the government to investigate further as it is a problem. 
Limitedmob – holding other variables constant, the models reveal that the likelihood of individuals who have limited mobility to have a poor health, which will lead to having a lower health in general, is 1.37 unit and 7.26% more likely. With a p-value of (<0.0001). Which is significant factor to consider, we see an illustration in graph 3 below: 
 
Cost_doc – holding all other variables constant, a one unit increase in cost_doc variable 0.24 implies that higher costs of healthcare services is associated with a probability 1.28% of poor health, general status 
Health_sats – holding all other variables constant, with an estimate of 2.65, indicating that the general health satisfaction of when self-rated from a scale of 1-10, has a higher probability of respondents giving a satisfaction of better general health. 
Employedstats: holding all other variables constant, the possibility of a respondents poor health having an impact on their employment status (i.e being unemployed due to having an illness) is 0.162 units more likely, and 0.86% more likely to have this affect their general health status. This can also be implied that individuals who are employed have a slightly higher probability of better general health compare to those who are unemployed. 
Accommodation_rot: Holding other variables constant, the models reveal that respondents who have rot/moulds in their accommodation is 0.29 unit increase and 1.52% more likely to have poor health. The low p-value (0.000) suggests a significant positive relationship. 
 
Accommodation_leak: holding other variables constant, the models reveal that a respondents who has leakage in accommodation is 0.082 with a high p-value of (0.2901) it suggests that there is a weak evidence to support a significant relationship between accommodation leaks and the bad health of respondents
Distance_doc: holding other variables constant, the models reveal that for respondents who had a bad health, had difficulty accessing a doctor in part due to the distance of the doctor, and is 0.42 unit and 2-27% more likely to be associated with bad health. The p-value (<0.0001) indicates a significant positive relationship.
Wait_time: holding all other variables constant. The models reveal that for respondents who experienced a long waiting time when attempting to see a doctor is 0.14 and 0.76% indicates that longer wait times for healthcare services and doctor’s appointment are associated with a bad health. With its p-value (0.0250) below significance level, which suggest a significantly positive relationship 
Healthquality: holding other variables constant, the models reveal that a respondent who rates the quality of healthcare poor is -0.16 a one-unit decrease and 0.86%, which implies that a higher rating in quality of healthcare service will result in reduced bad health. P-value (0.0015) below significance indicates a non-significant relationship between the health quality and genhealth.  





3.	Conclusion
The regression models performed well and produced results, which indicated that certain variables have significant associations with bad health. The logit model performs better in comparison. The findings highlight the importance of addressing these factors to improve the overall health status of individuals. Further investigations and strategies are recommended to tackle these issues and promote better health outcomes.
On this basis the following are recommended 
1. Improve access to healthcare services by reducing wait times and increasing the availability of doctors.
2. Enhance the quality of healthcare services to ensure better health outcomes.
3.  Implement measures to reduce healthcare costs and provide financial assistance to those in need.
Recommendations for the models
1. Training on data that are more recent
2. Training the model on specific datasets, 
3. User feedback and iteration





