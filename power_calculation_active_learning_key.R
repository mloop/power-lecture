library(tidyverse)
library(simglm)


set.seed(324098) # set your random seed

sim_arguments <- list(
  formula = percent_change ~ 1 + treatment_group + sex + age,  # specify the names of the covariates you are using
  
  fixed = list(treatment_group = list(var_type = 'factor', levels = c("standard", "new")),
               sex = list(var_type = 'factor', levels = c("male", "female")),
               age = list(var_type = 'continuous', mean = 62, sd = 3 )
               ),  # specify distribution of covariates
  
  sample_size = 35,  # you will need to choose a sample size to try
  
  error = list(variance = 20),  # specify residual variance of outcome
  
  reg_weights = c(-10, -5, -2.5, 0.01),  # specify the regression parameter / coefficient values for the treatment, sex, and age variables
  
  replications = 1000,  # you can choose this to be what you want. several hundred to a couple of thousand iterations should do the trick
  
  extract_coefficients = TRUE,
  model_fit = list(
    model_function = 'lm',
    formula = percent_change ~ 1 + treatment_group + sex + age # specify the names of the covariates you are using
  ),
  reg_weights_model = c(-10, -5, -2.5, 0.01)  # specify again the regression parameter values you are using
)

# Now run this to get the power and other results

replicate_simulation(sim_arguments) %>%
  compute_statistics(sim_arguments)
