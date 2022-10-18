# Meta --------------------------------------------------------------------

## Author:        Martha Wetzel
## Date Created:  10/11/22
## Notes:         Data prep through question 2 was done in SAS (01_Prep.sas)


# Preliminaries -----------------------------------------------------------

pacman::p_load(tidyverse, ggplot2, dplyr, lubridate, kableExtra, modelsummary, 
               fixest, gt, flextable, stringr, rmarkdown, haven, robomit, ivreg, plm,
               broom, modelr, ivmodel, scales)

# Set up some output formatting for modelsummary
f <- function(x) formatC(x, digits = 2, big.mark = ",", format = "f")


# Import the files
ppas_puf <- read_sas("../Output/SAS Temp/ppas_puf.sas7bdat")
pfs <- read.table("../Raw Data/PFS_update_data.txt",  sep="\t", header=TRUE)

puf_psy_2012 <- read_sas("../Output/SAS Temp/puf_psy_2012.sas7bdat")

mdppas2009 <- read_sas("../Output/SAS Temp/MDPPAS_2009.sas7bdat") %>% 
  select("npi","group1")


#---- Question 2 - Plot ----
# Note: Most of the data prep for question 2 was done in the 01_Prep.sas program
ppas_puf <- ppas_puf %>% mutate(services_log = log(line_srvc_cnt)) 
  
ppas_puf_lt <- ppas_puf %>% filter(Year>2012)

ppas_puf_lt$Int_F <- factor(ppas_puf_lt$Int,
       levels = c(0,1),
       labels = c("Not Integrated", "Integrated"))




q2_data <- ppas_puf_lt %>% group_by(Year, Int_F ) %>% 
  summarise(Mean=mean(line_srvc_cnt,na.rm=TRUE))

q2_plot <- ggplot(data=q2_data, aes(x=Year, y=Mean, group=Int_F)) +
  geom_line(aes(linetype=Int_F, color=Int_F), size = 1.2)+
  scale_y_continuous(labels = label_number(big.mark = ",")) +
  ylab("Mean Services")+
  xlab("Year") +
  labs(linetype=" ", color=" ") +
  theme_classic()

q2_plot





#---- Question 3 ----

ppas_puf$Int_L <- as.logical(ppas_puf$Int)

ols_q3 <- feols(services_log ~ Int_L + Age  | npi + Year, data=ppas_puf)

summary(ols_q3)

cm <- c("Int_LTRUE"="Integration", "Age"="Age")
models <- list("Services on Integration"=ols_q3)
q3_twfe <- modelsummary(models, estimate= "{round(exp(estimate),2)}",
                        statistic = "[{round(exp(conf.low),2)}, {round(exp(conf.high),2)}]",
                        gof_omit = 'AIC|BIC|RMSE', coef_map = cm,
                        output = "flextable", fmt=NULL)
q3_twfe

#---- Question 4 ----

# Oster omitted variable bias



R2_List <- list(0.5,0.6,0.7,0.8,0.9,1)
delta_list <- list(0.5, 1, 1.5, 2)

for (r in R2_List){
  for (d in delta_list){
  betaest <- o_beta(y="services_log", x="Int", con="Age", m = "none", w = NULL, 
                                     id = "npi", time = "Year", delta = d,
                                     R2max=r, type="lm", data=ppas_puf_lt)
  colnames(betaest)[2] = paste0("value_r",r,"d",d)
  
  assign(paste0("bias_r",r,"d", d),betaest) 
  
  }

}
q4_list <- mget(ls(pattern = "bias_r.*"))
q4_all <- q4_list %>% reduce(full_join, by='Name')

# Someday I'll master the reshaping functions in R but that day isn't today
write_csv(q4_all, "../Output/Q4_Values.csv")



#---- Question 5 ----

#---- Set up the instrument ----

for (i in 2012:2017) {
  # Prepare the physician-service-year data
  puf_psy <- read_sas(paste0("../Output/SAS Temp/puf_psy_",i,".sas7bdat"))
  puf_psy$npi <- as.double(puf_psy$npi)
 
  # Choose the service fee-year data - 2012 for 2012, 2013 for all years after 2013
  yr4pfs <- min(i, 2013)
  pfs_yr <- pfs %>% filter(year==yr4pfs)
  
  # Construct the instrument
  price.shock <- puf_psy %>% inner_join(mdppas2009, by="npi") %>%
    inner_join(pfs_yr %>% 
                 select(hcpcs, dprice_rel_2010, price_nonfac_orig_2010, price_nonfac_orig_2007), 
               by=c("hcpcs_code"="hcpcs")) %>%
    mutate_at(vars(dprice_rel_2010, price_nonfac_orig_2010, price_nonfac_orig_2007), replace_na, 0) %>%
    mutate(price_shock = case_when(
      i<=2013 ~ ((i-2009)/4)*dprice_rel_2010,
      i>2013  ~ dprice_rel_2010),
      denom = line_srvc_cnt*price_nonfac_orig_2010,
      numer = price_shock*line_srvc_cnt*price_nonfac_orig_2010) %>%
    group_by(npi) %>%
    dplyr::summarize(phy_numer=sum(numer, na.rm=TRUE), phy_denom=sum(denom, na.rm=TRUE), tax_id=first(group1)) %>%
    ungroup() %>%
    mutate(phy_rev_change=phy_numer/phy_denom) %>%    
    group_by(tax_id) %>%
    dplyr::summarize(practice_rev_change=sum(phy_rev_change, na.rm=TRUE)) %>%
    ungroup() %>%
    mutate(year=i)
  
    assign(paste0("iv_",i),price.shock) 
  
}

rm(price.shock, puf_psy, mdppas2009)

# Stack IV data sets 
all_iv <- rbind(iv_2012, iv_2013, iv_2014, iv_2015, iv_2016, iv_2017)
save(all_iv,  file="./ivs.Rdata.")

rm(iv_2012, iv_2013, iv_2014, iv_2015, iv_2016, iv_2017)

# Merge the IV back with mdppas 2009 to get the NPIs, then merge with ppas_puf for regression
npi_iv <- inner_join(x=mdppas2009, y=all_iv, by=c("group1"="tax_id"))


ppas_puf <- ppas_puf %>% inner_join(npi_iv, by = c("npi","Year"="year"))

#---- Regression ----


# Prep data by specifying index of panel structure
ppas_puf_plm <- pdata.frame(ppas_puf, index=c("npi","Year"),  row.names=TRUE)
head(attr(ppas_puf_plm, "index"))


iv_q5 <- plm(services_log ~ Age + Int  | practice_rev_change + Age,
          data = ppas_puf_plm, model = "within", effect = "twoways")

summary(iv_q5)

#Plm doesn't play with modelsummary, arg
iv_q5_feol = feols(services_log ~ Age | npi + Year | Int ~ practice_rev_change , ppas_puf)



# Do two-stage results separately, which will mess up SE

# Stage 1
iv_s1_q5 <- feols(Int ~ practice_rev_change + Age  | npi + Year, data=ppas_puf)


# Stage 2
ppas_puf <- add_predictions(data=ppas_puf, model=iv_s1_q5)

iv_s2_q5 <- feols(services_log ~ pred + Age   | npi + Year, data=ppas_puf)

# Reduced form

reduced_q5 <- feols(services_log ~ practice_rev_change + Age   | npi + Year, data=ppas_puf)


coefname <- c("fit_Int"= "Integration", 
              "practice_rev_change"="Expected Revenue Change", 
              "Age"="Age")

models <- list("2SLS"=iv_q5_feol, 
               "Stage 1"=iv_s1_q5,
               "Reduced Form"=reduced_q5)


q5_all <- modelsummary(models, 
                       estimate= c("{round(exp(estimate),2)} [{round(exp(conf.low),2)}, {round(exp(conf.high),2)}]",
                                   "{round(exp(estimate),5)} [{round(exp(conf.low),5)}, {round(exp(conf.high),5)}]",
                                   "{round(exp(estimate),4)} [{round(exp(conf.low),4)}, {round(exp(conf.high),4)}]"
                                           ),
                       statistic = NULL,
                       gof_omit = 'AIC|BIC|RMSE', coef_rename =coefname,
                      output = "flextable", fmt = NULL)

#---- Question 6 ----

# We start with the first stage from q5

# add residuals 
ppas_puf <- add_residuals(ppas_puf, iv_s2_q5, var = "resid_s1")
iv_dwh_q6 <- feols(services_log ~ Int + Age + resid_s1  | npi + Year, data=ppas_puf)


#---- Question 7 ----
ppas_puf$npi <- as.factor(ppas_puf$npi)
ppas_puf$Year <- as.factor(ppas_puf$Year)

ppas_puf <- ppas_puf %>% filter(!is.na(Age)) %>% filter(!is.na(Int))

Y=as.numeric(unlist(ppas_puf[,"services_log"]))
D=as.numeric(unlist(ppas_puf[,"Int"]))
Z=as.numeric(unlist(ppas_puf[,"practice_rev_change"]))

Xname = c("Age","Year")
X=ppas_puf[,Xname]
X=as.numeric(unlist(ppas_puf[,"Age"]))

npi <- ppas_puf[,"npi"]


q7_model <- ivmodel(Y, D, Z, X, intercept = TRUE,
        beta0 = 0, alpha = 0.05)


checkiv <- ivreg(services_log ~ Age + Int | practice_rev_change + Age, data=ppas_puf)



# Part 7b - go back to the first stage f-statistic since ivreg was a fail 
est_ivfeols




#---- Question 8  ----






#---- Save for output
save.image(file="./backup.RData")
save(q2_plot, q3_twfe, q5_all, iv_dwh_q6, q7_model, est_ivfeols, file="../Output/output.RData" )




