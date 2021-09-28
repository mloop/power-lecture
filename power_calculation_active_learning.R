library(tidyverse)
library(simglm)


set.seed() # set your random seed

sim_arguments <- list(
  formula =  ~ 1 + ,  # specify the names of the covariates you are using
  
  fixed = list( = list(var_type = 'factor', levels = c()),
                = list(var_type = 'factor', levels = c()),
                = list(var_type = 'continuous', mean = , sd = )),  # specify distribution of covariates
  
  sample_size = ,  # you will need to choose a sample size to try
  
  error = list(variance = ),  # specify residual variance of outcome
  
  reg_weights = c(),  # specify the regression parameter / coefficient values for the treatment, sex, and age variables
  
  replications = ,  # you can choose this to be what you want. several hundred to a couple of thousand iterations should do the trick
  
  extract_coefficients = TRUE,
  model_fit = list(
    model_function = 'lm',
    formula =  ~ 1 +  # specify the names of the covariates you are using
  ),
  reg_weights_model = c()  # specify again the regression parameter values you are using
)

# Now run this to get the power and other results

replicate_simulation(sim_arguments) %>%
  compute_statistics(sim_arguments)
