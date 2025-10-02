#!/usr/bin/env Rscript
# Complete Statistical Analysis for Amyloid PET Data
# CONNExIN Week 7 - Final Statistical Pipeline

# Load required packages
required_packages <- c("tidyverse", "car", "emmeans", "ggplot2", "broom", "readr")
invisible(lapply(required_packages, library, character.only = TRUE))

# Set working directory
setwd("/home/jovyan/Desktop/dataset/derivatives/analysis")

main <- function() {
  cat("AMYLOID PET STATISTICAL ANALYSIS PIPELINE\n")
  cat("==========================================\n\n")
  
  # Load data
  if (file.exists("extracted_suvr_values.csv")) {
    suvr_data <- read_csv("extracted_suvr_values.csv")
    cat("✓ Data loaded successfully\n")
  } else {
    cat("✗ Error: extracted_suvr_values.csv not found\n")
    return(FALSE)
  }
  
  # Data preparation
  suvr_data$group <- factor(suvr_data$group, levels = c("Control", "MCI", "AD"))
  
  # Descriptive statistics
  cat("\n1. DESCRIPTIVE STATISTICS:\n")
  desc_stats <- suvr_data %>%
    group_by(group) %>%
    summarise(
      n = n(),
      mean_global = mean(global_suvr),
      sd_global = sd(global_suvr),
      mean_precuneus = mean(precuneus_suvr),
      sd_precuneus = sd(precuneus_suvr),
      .groups = 'drop'
    )
  print(desc_stats)
  
  # One-way ANOVA
  cat("\n2. ONE-WAY ANOVA RESULTS:\n")
  anova_model <- aov(global_suvr ~ group, data = suvr_data)
  anova_summary <- summary(anova_model)
  print(anova_summary)
  
  # Extract p-value
  p_value <- summary(anova_model)[[1]]$"Pr(>F)"[1]
  
  # Effect size
  ss_total <- sum(anova_model$residuals^2) + sum(anova_model$fitted^2)
  ss_effect <- sum(anova_model$fitted^2)
  eta_sq <- ss_effect / ss_total
  
  cat(sprintf("\nEffect size (Eta-squared): %.3f\n", eta_sq))
  
  # Post-hoc analysis if significant
  if (p_value < 0.05) {
    cat("\n3. POST-HOC ANALYSIS (Tukey HSD):\n")
    tukey_results <- TukeyHSD(anova_model)
    print(tukey_results)
  }
  
  # Create visualization
  cat("\n4. GENERATING VISUALIZATIONS...\n")
  p <- ggplot(suvr_data, aes(x = group, y = global_suvr, fill = group)) +
    geom_boxplot(alpha = 0.7) +
    geom_point(position = position_jitter(width = 0.2), size = 2) +
    labs(title = "Amyloid Deposition Across Diagnostic Groups",
         subtitle = paste("ANOVA p =", round(p_value, 4)),
         x = "Diagnostic Group",
         y = "Global SUVR",
         caption = "Dashed line indicates amyloid positivity threshold (SUVR = 1.4)") +
    geom_hline(yintercept = 1.4, linetype = "dashed", color = "red", alpha = 0.7) +
    theme_minimal() +
    scale_fill_brewer(palette = "Set2")
  
  ggsave("final_statistical_results.png", p, width = 10, height = 6, dpi = 300)
  cat("✓ Visualization saved: final_statistical_results.png\n")
  
  # Save results
  results <- list(
    descriptives = desc_stats,
    anova = anova_summary,
    effect_size = eta_sq,
    significant = p_value < 0.05
  )
  
  saveRDS(results, "statistical_results.rds")
  cat("✓ Results saved: statistical_results.rds\n")
  
  cat("\n=== STATISTICAL ANALYSIS COMPLETE ===\n")
  return(TRUE)
}

# Run analysis
if (!interactive()) {
  success <- main()
  quit(save = "no", status = ifelse(success, 0, 1))
}
