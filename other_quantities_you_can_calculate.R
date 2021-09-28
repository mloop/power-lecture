# you can find this code file at https://github.com/mloop/power-lecture/blob/main/simglm_example.R. 

library(tidyverse)
library(simglm)
library(broom)


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

simulations <- tibble(iteration = seq(1, 500)) %>%
  group_by(iteration) %>%
  nest() %>%
  mutate(
    sims = map(data, ~simulate_fixed(data = NULL, sim_arguments) %>%
      simulate_error(sim_arguments) %>%
      generate_response(sim_arguments) %>%
      model_fit(sim_arguments) %>% 
      tidy()
    )
  )

simulations %>%
  unnest(sims) %>%
  ungroup() %>%
  select(iteration, term, estimate) %>%
  pivot_wider(names_from = "term", values_from = "estimate") %>%
  summarise(
    prev_diff_lt_0 = mean(if_else(treatment_grouptreatment < 0, 1, 0)),
    prev_overestimate_by_2 = mean(if_else(treatment_grouptreatment > 5, 1, 0))
  )

p <- simulations %>%
  unnest(sims) %>%
  ungroup() %>%
  select(iteration, term, estimate) %>%
  ggplot(aes(x = estimate)) +
  geom_histogram() +
  facet_wrap(~ term, scales = "free_x")

ggsave(filename = "estimates_histogram.png", p)