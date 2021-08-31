library(tidyverse)
library(simglm)


set.seed(321)  # you are randomly simulating data. in order to reproduce the same result every time, you have to set the starting random number, or the "seed"

# ANOVA

sim_arguments <- list(
  formula = y ~ 1 + treatment_group,  # formula that generates data
  
  fixed = list(treatment_group = list(var_type = 'factor', levels = c("placebo", "low dose", "high dose"))),  # specify distribution of covariates
  
  sample_size = 100,
  
  error = list(variance = 50),  # specify residual error of outcome
  
  reg_weights = c(50, 2.5, 5),  # regression parameters (intercept and treatment difference)
  
  replications = 500,
  
  extract_coefficients = TRUE,
  model_fit = list(
    model_function = 'lm'
  )
)

x <- vector()
for(i in 1:500){
  
  x[i] <- simulate_fixed(data = NULL, sim_arguments) %>%
    simulate_error(sim_arguments) %>%
    generate_response(sim_arguments) %>%
    model_fit(sim_arguments) %>% anova() %>% as_tibble() %>% select(`Pr(>F)`) %>% slice(1) %>% pull()
}
y <- if_else(x < 0.05, 1, 0)
mean(y)