plot_binomial <- function(n = 100, p = 0.5) {
  # n <- 45      # Number of trials (e.g., sample size)
  # p <- 0.52    # Probability of success on a single trial

  # --- Calculations ---
  # Binomial distribution parameters
  mu <- n * p # Mean (Expected Value) of the binomial distribution
  sigma <- sqrt(n * p * (1 - p)) # Standard Deviation of the binomial distribution

  # Boundaries for the shaded area: Mean ± 1 Standard Deviation
  shade_min <- mu - sigma
  shade_max <- mu + sigma

  # --- Data Preparation ---
  # Create a sequence of possible outcomes (number of successes)
  x_values <- 0:n
  # Calculate the exact binomial probability for each outcome
  binom_probs <- dbinom(x_values, size = n, prob = p)
  # Combine into a data frame for plotting
  plot_data <- data.frame(x = x_values, probability = binom_probs)

  # Calculate the peak height of the normal approximation curve (for annotation positioning)
  # dnorm gives the probability density function value
  norm_peak_height <- dnorm(mu, mean = mu, sd = sigma)

  # --- Plotting ---
  ggplot(plot_data, aes(x = x, y = probability)) +

    # Layer 1: Binomial distribution bars
    # Using geom_col for discrete values. Added a slight width adjustment for visual spacing.
    geom_col(fill = "lightblue", color = "navy", width = 0.75) +

    # Layer 2: Shaded area for Mean ± 1 Standard Deviation
    # Using annotate("rect", ...) is often preferred for fixed rectangles not mapped to data aesthetics.
    # Increased alpha slightly for better visibility if bars are dense.
    annotate(
      "rect",
      xmin = shade_min,
      xmax = shade_max,
      ymin = 0,
      ymax = Inf, # ymax=Inf extends shading to top
      fill = "lightgreen",
      alpha = 0.3 # Use alpha for transparency
    ) +

    # Layer 3: Normal Approximation Curve
    # stat_function plots a function based on the x-axis values.
    # Using 'linewidth' instead of 'size' (more modern ggplot2 parameter).
    stat_function(
      fun = function(val) dnorm(val, mean = mu, sd = sigma), # Normal PDF
      color = "darkgreen",
      linewidth = 1.2
    ) +

    # Layer 4: Vertical line for the Mean (μ)
    geom_vline(
      xintercept = mu,
      color = "red",
      linetype = "dashed",
      linewidth = 1.1 # Make it slightly thicker than SD lines
    ) +

    # Layer 5: Vertical lines for Mean ± 1 Standard Deviation boundaries
    geom_vline(
      xintercept = c(shade_min, shade_max),
      color = "darkgrey", # Less prominent color than the mean line
      linetype = "dotted", # Different linetype
      linewidth = 0.8
    ) +

    # --- Labels and Annotations ---
    labs(
      title = paste("Binomial Distribution (n =", n, ", p =", p, ")"),
      subtitle = paste(
        "Mean (μ) =",
        sprintf("%.1f", mu),
        "; Std Dev (σ) =",
        sprintf("%.1f", sigma),
        "\nShaded area shows μ ± 1σ (",
        sprintf("%.1f", shade_min),
        "to",
        sprintf("%.1f", shade_max),
        ")"
      ),
      x = "Number of Successes",
      y = "Probability / Density" # Acknowledge y-axis represents both
    ) +

    # Annotation for the Mean value, positioned dynamically near the normal peak
    annotate(
      "text",
      x = mu,
      y = norm_peak_height * 1.05, # Position slightly above the normal curve peak
      label = paste("μ =", sprintf("%.2f", mu)),
      color = "red",
      hjust = 0.5, # Center horizontally over the mean line
      vjust = 0 # Align bottom of text with y coordinate
    ) +

    # --- Theme and Scales ---
    theme_minimal(base_size = 14) + # Clean theme
    scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
    scale_y_continuous(labels = scales::comma_format())
}
