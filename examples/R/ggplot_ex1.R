## Stats 506, F20
## ggplot examples, 1
## 
## This script explores options for plotting multiple estimates together in
## order to emphasize specific comparisons. 
##
## The RData file recs2015_temps.RData contains a tibble `temps` with estimates
## of residential wintertime temperatures organized by:
##  1. census division
##  2. rurality
##  3. time of day (daytime/at home, daytime/away, night)
##
## Author: James Henderson, jbhender@umich.edu
## Updated: October 7, 2020
# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(tidyverse)

# directories: ----------------------------------------------------------------
path = '~/github/Stats506_F20/examples/data'
foo = load(sprintf('%s/recs2015_temps.RData', path)) #temps

# put the plot in order: ------------------------------------------------------

### order divisions by average "home" temp 
div_order = 
  with(
    temps %>%
      filter( type == 'home' ) %>%
      group_by( division ) %>%
      summarize( est = mean(est), .groups = 'drop' ) %>%
      arrange(est),
    as.character( division) 
  )

# plot 1: ---------------------------------------------------------------------
# division - axis 
# urban type - color
# temp type - facets
temps_plot1 = 
  temps %>%
  mutate( 
    division = factor(division, levels = div_order),
    `Urban Type` = urban
  ) %>%
  ggplot( aes(y = est, x = division, color = `Urban Type`) ) +
  geom_point( position = position_dodge(width = .5), alpha = 0.5 ) +
  geom_errorbar(
    aes(ymin = lwr, ymax = upr), 
    alpha = 0.5, 
    position = position_dodge(width = .5)
  ) + 
  coord_flip() +
  facet_wrap(~ type) + 
  theme_bw() +
  scale_color_manual( values = c('goldenrod', 'darkorange', 'black') ) +
  ylab( expression('Temperature ' (degree*'F')) ) +
  ylim( c(60, 75) ) +
  xlab('')

# plot 2: ---------------------------------------------------------------------
# division - axis 
# urban type - facets
# temp type - color
temps_plot2 = 
  temps %>%
  mutate( 
    division = factor(division, levels = div_order),
    `Temperature Type` = type
  ) %>%
  ggplot( aes(y = est, x = division, color = `Temperature Type`) ) +
  geom_point( position = position_dodge(width = .5), alpha = 0.5 ) +
  geom_errorbar( 
    aes(ymin = lwr, ymax = upr), 
    alpha = 0.5, 
    position = position_dodge(width = .5)
  ) + 
  coord_flip() +
  facet_wrap(~ urban) + 
  theme_bw() +
  scale_color_manual( values = c('goldenrod', 'darkorange', 'black') ) +
  ylab( expression('Temperature ' (degree*'F')) ) +
  ylim( c(60, 75) ) +
  xlab('')

# plot 3: ---------------------------------------------------------------------
# division - axis 
# urban type - facets
# temp type - shape
temps_plot3 = 
  temps %>%
  mutate( 
    division = factor(division, levels = div_order),
    `Temperature Type` = type
  ) %>%
  ggplot( aes(y = est, x = division, shape = `Temperature Type`) ) +
  geom_errorbar( 
    aes(ymin = lwr, ymax = upr), 
    alpha = 0.5, 
    position = position_dodge(width = .5)
  ) + 
  geom_point( position = position_dodge(width = .5) ) +
  coord_flip() +
  facet_wrap(~ urban) + 
  theme_bw() +
  scale_shape_manual( values = 15:17 ) +
  ylab( expression('Temperature ' (degree*'F')) ) +
  ylim( c(60, 75) ) +
  xlab('')

# plot 4: ---------------------------------------------------------------------
# division - axis 
# urban type - color
# temp type - shape
temps_plot4 = 
  temps %>%
  mutate( 
    division = factor(division, levels = div_order),
    `Temperature Type` = type,
    `Urban Type` = urban
  ) %>%
  ggplot( 
    aes(y = est, 
        x = division, 
        color = `Urban Type`,
        shape = `Temperature Type`
    ) 
  ) +
  geom_errorbar( 
    aes(ymin = lwr, ymax = upr), 
    alpha = 0.5, 
    position = position_dodge(width = .75)
  ) + 
  geom_point( position = position_dodge(width = .75) ) +
  coord_flip() +
  theme_bw() +
  scale_color_manual( values = c('goldenrod', 'darkorange', 'black') ) +
  scale_shape_manual( values = 15:17 ) +
  ylab( expression('Temperature ' (degree*'F')) ) +
  ylim( c(60, 75) ) +
  xlab('')

# plot 5: ---------------------------------------------------------------------
# division - axis 
# urban type - row facets
# temp type -  col facets
temps_plot5 = 
  temps %>%
  mutate( 
    division = factor(division, levels = div_order),
    `Temperature Type` = type
  ) %>%
  ggplot( aes(y = est, x = division) ) +
  geom_errorbar( 
    aes(ymin = lwr, ymax = upr), 
    alpha = 0.5, 
    position = position_dodge(width = .5)
  ) + 
  geom_point( position = position_dodge(width = .5) ) +
  coord_flip() +
  facet_grid(type ~ urban) + 
  theme_bw() +
  ylab( expression('Temperature ' (degree*'F')) ) +
  ylim( c(60, 75) ) +
  xlab('')

# plot 6: ---------------------------------------------------------------------
# division - axis / color
# urban type - row facets
# temp type -  col facets
temps_plot6 = 
  temps %>%
  mutate( 
    division = factor(division, levels = div_order),
    `Temperature Type` = type
  ) %>%
  ggplot( aes(y = est, x = division, color = division) ) +
  geom_errorbar( 
    aes(ymin = lwr, ymax = upr), 
    alpha = 0.5, 
    position = position_dodge(width = .5)
  ) + 
  geom_point( position = position_dodge(width = .5) ) +
  coord_flip() +
  facet_grid(type ~ urban) + 
  theme_bw() +
  theme(axis.text.y = element_blank()) + 
  ylab( expression('Temperature ' (degree*'F')) ) +
  ylim( c(60, 75) ) +
  xlab('')
