# you can find this code file at https://github.com/mloop/power-lecture/blob/main/simglm_example.R. 

library(tidyverse)
library(simglm)


set.seed(321)  # you are randomly simulating data. in order to reproduce the same result every time, you have to set the starting random number, or the "seed"

# t-test
sim_arguments <- list(
  formula = y ~ 1 + treatment_group,  # formula that generates data
  
  fixed = list(treatment_group = list(var_type = 'factor', levels = c("placebo", "treatment"))),  # specify distribution of covariates
  
  sample_size = 100,
  
  error = list(variance = 50),  # specify residual error of outcome
  
  reg_weights = c(50, 2.5),  # regression parameters (intercept and treatment difference)
  
  replications = 500,
  
  extract_coefficients = TRUE,
  model_fit = list(
    model_function = 'lm'
  )
)

power_results <- replicate_simulation(sim_arguments) %>%
  compute_statistics(sim_arguments)

power_results

# regression with adjusting for baseline

sim_arguments <- list(
  formula = y ~ 1 + treatment_group + age,  # formula that generates data
  
  fixed = list(treatment_group = list(var_type = 'factor', levels = c("placebo", "treatment")),
               age = list(var_type = "continuous", mean = 50, sd = 5)),  # specify distribution of covariates
  
  sample_size = 100,
  
  error = list(variance = 50),  # specify residual error of outcome
  
  reg_weights = c(50, 2.5, 2),  # regression parameters (intercept and treatment difference)
  
  replications = 500,
  
  extract_coefficients = TRUE,
  model_fit = list(
    model_function = 'lm',
    formula = y ~ 1 + treatment_group + age
  ),
  reg_weights_model = c(50, 2.5, 2)
)

power_results <- replicate_simulation(sim_arguments) %>%
  compute_statistics(sim_arguments)

power_results

# logistic

sim_arguments <- list(
  formula = y ~ 1 + treatment_group + age,  # formula that generates data
  
  fixed = list(treatment_group = list(var_type = 'factor', levels = c("placebo", "treatment")),
               age = list(var_type = "continuous", mean = 50, sd = 5)),  # specify distribution of covariates
  
  sample_size = 100,
  
  reg_weights = c(-2, 0.5, 0.1),  # regression parameters must be specified on the logit scale
  
  replications = 500,
  
  extract_coefficients = TRUE,
  model_fit = list(
    model_function = 'glm',
    formula = y ~ 1 + treatment_group + age,
    family = "binomial"
  ),
  reg_weights_model = c(-2, 0.5, 0.1),
  outcome_type = "binary"
)

rstanarm::invlogit(-2)
rstanarm::invlogit(-2 + 0.5)

power_results <- replicate_simulation(sim_arguments) %>%
  compute_statistics(sim_arguments)

power_results
