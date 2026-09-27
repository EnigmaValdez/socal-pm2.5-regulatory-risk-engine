# ╔════════════════════════════════════════════════════════════════════════════╗
# ║ ========================================================================== ║
# ║                                                                            ║                                                                  
# ║ GENERATING A BAR CHART FOR AIR POLLUTION LEVELS IN US STATES               ║
# ║                                                                            ║
# ║ ========================================================================== ║
# ║                                                                            ║
# ║ PURPOSE ------------------------------------------------------------------ ║                                   ║
# ║ This code is used to create a bar graph for air pollution levels in        ║
# ║ US states. The graph shows the counties in a specified US state with the   ║
# ║ highest PM2.5 levels and also indicates the percent of state population    ║
# ║ living in areas where PM2.5 levels are above the US Environmental          ║
# ║ Protection Agency (US EPA) standard of 9µg/m³.                             ║
# ║                                                                            ║
# ║                                                                            ║
# ║ ABOUT THE CODE ----------------------------------------------------------- ║
# ║
# ║                                                                            ║
# ║ HOW I ACCESSED AND EXPORTED THE DATA ------------------------------------  ║
# ║ Source: National Environmental Public Health Tracking Network,             ║
# ║ Data Explorer tool (2020). https://ephtracking.cdc.gov/DataExplorer/       ║                                                                  
# ║                                                                            ║
# ║ In the 'Query Panel' - For PM2.5 data:                                     ║
# ║ 1. Selected Content Area - 'Air Quality'                                   ║
# ║ 2. Selected Indicator - 'Current and Historical Air Quality'               ║
# ║ 3. Selected Measure - 'Highest Annual Average Concentration (Monitor +     ║
# ║    Modeled Data)'                                                          ║
# ║ 4. Selected Geographic Type - 'National by County'                         ║
# ║ 5. Keep 'All Counties' under 'Geography' selected                          ║
# ║ 6. Selected Year - '2020'                                                  ║
# ║ 7. Click 'Go'                                                              ║
# ║                                                                            ║
# ║ In the 'Query Panel' - For population data:                                ║
# ║ 1. Select Content Area - 'Demographics and Socioeconomics'                 ║
# ║ 2. Select Indicator - 'Demographics'                                       ║
# ║ 3. Select Measure - 'Number of people by Demographics'                     ║                                                          
# ║ 4. Select Geographic Type - 'National by County'                           ║
# ║ 5. Keep 'All Counties' under 'Geography' selected                          ║
# ║ 6. Select Year - '2020'                                                    ║
# ║ 7. Did not select anything under 'Advanced Options'                        ║
# ║ 8. Clicked 'Go'                                                            ║
# ║                                                                            ║
# ║                                                                            ║
# ║                                                                            ║
# ║ ========================================================================== ║
# ║                                                                            ║
# ║ ATTRIBUTION & REUSE OF CODE                                                ║
# ║                                                                            ║
# ║ ========================================================================== ║
# ║                                                                            ║
# ║ Copyright License: Creative Commons Attribution-NonCommercial-ShareAlike   ║ 
# ║ 4.0 International.                                                         ║
# ║                                                                            ║
# ║                                                                            ║
# ║                                                                            ║
# ║                                                                            ║
# ║ I adapted and modified the code                                            ║
# ║ from code shared by BroadStreet Institute (www.broadstreet.org) and        ║
# ║ created by Teresa Tse and Shamini De Silva. Redistribution, edits, and     ║
# ║ sharing permitted with attribution under Creative Commons                  ║    
# ║ Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)   ║
# ║ license."                                                                  ║  
# ║                                                                            ║ 
# ║ ========================================================================== ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# (you only need to install packages once, if they are not already installed)
install.packages('tidyverse') # install tidyverse package - key for data wrangling and visualization
install.packages('scales') # install scales package for scaling functions like label_number() (see below for exact usage)

library(tidyverse) # load tidyverse package
library(scales) # load scales package

your_state <- 'California' # specify your state

# change the right-hand side IF the files you downloaded have different names
file_name_pm25_data <- 'pm_2020.csv'
file_name_pop_data <- 'population_data_2020.csv'
file_name_fips_data <- 'fips_counties_2021.txt'

# YOU DO NOT NEED TO CHANGE ANYTHING BEYOND THIS POINT

# PART I: find the percent of population in a state living in counties where PM2.5 level is ≥9ug/m3----

# import pm25 data from the 'pm_2020.csv' file and select for specific columns 
pm25 <- read_csv(file_name_pm25_data) |> # read .csv file and assign data to pm25 variable
  select(CountyFIPS, pm25_level=Value) # select for CountyFIPS column and rename 'Value' column to 'pm25_level'

# import population data from the 'population_data_2020.csv' file and select for specific columns
pop_all_counties_2020 <- read_csv(file_name_pop_data) |> # read .csv file and assign data to pop_all_counties_2020
  select(State, CountyFIPS, population_number=Value) # select for State and CountyFIPS columns and rename 'Value' column to 'population_number'

# create a data frame to summarize the percent of the population in your_state living in areas where PM2.5 ≥9ug/m3
percent_pop_high_pollution <- pop_all_counties_2020 |> 
  left_join(pm25, by = join_by(CountyFIPS)) |> # join the pm2.5 data frame with the population data frame through the county FIPS codes column which is common to both data frames
  mutate(high_pollution = if_else(pm25_level >= 9, 1, 0)) |> # add a column to specify if county has PM2.5 ≥9ug/m3 (1) or not (0)
  filter(State == your_state) |>  # filters for your specified state
  summarise( 
    pop_high_pollution = (sum(population_number*high_pollution, na.rm = TRUE)), # sums up population number in the state living in high pollution area  
    pop = sum(population_number, na.rm = TRUE), # sums up population in the state
    percent_pop = round(pop_high_pollution/pop*100, 1)) |> # calculates the percent of population in a state living in a high pollution area
  mutate(pop_text = label_number(scale_cut = c(' ' = 0, ' thousand' = 1e3, ' million' = 1e6), accuracy = 1)(pop_high_pollution)) # using label_number() to round the population number to the nearest million or thousand and add text 'million' or 'thousand'

# create a data frame to sumamrize the percent of US population living in areas where PM2.5 is ≥9ug/m3
percent_pop_high_pollution_US <- pop_all_counties_2020 |> 
  left_join(pm25, by = join_by(CountyFIPS)) |> 
  mutate(high_pollution = if_else(pm25_level >= 9, 1, 0)) |> 
  summarise(pop_high_pollution = (sum(population_number*high_pollution, na.rm = TRUE)),
            pop = sum(population_number, na.rm = TRUE),
            percent_pop = round(pop_high_pollution/pop*100)) |> 
  mutate(State = 'United States', .before = pop_high_pollution)


# PART II: create a bar graph to show counties with highest PM2.5 levels in the specified state----

# prepare data for bar graph
# Import FIPS code data for US counties in 2021. 
# Please note: could be a problem for states that have updated their counties since 2021.
fips <- read_tsv(file_name_fips_data)

# create a data frame identifying and summarizing the three counties in your_state with highest PM2.5 levels
state_top3 <- pm25 |> 
  left_join(fips, by = join_by(CountyFIPS)) |> # join fips data with PM2.5 data using the common CountyFIPS column in both data frames
  filter(State == your_state) |> # filter for your state
  arrange(desc(pm25_level)) |> # arrange in descending order
  slice_head(n = 3) |>  # slice for just top 3
  mutate(county = fct_inorder(county)) |> # set the levels in the order of the column (keeps bars in this order in bar chart)
  select(county, pm25_level) # select just the County name and PM2.5 level columns
  
# plot a bar graph to showcase the counties with the highest PM2.5 levels and how they compare to the EPA standard
ggplot(state_top3, aes(x = pm25_level, y = fct_rev(county))) + # fct_rev() makes bars go from highest (top) to lowest (bottom)
  geom_bar(stat = 'identity', fill = '#D7907B', width = 0.7) + 
  geom_text(
    label = str_glue('{state_top3$pm25_level} µg/m³'), # adds label at the end of bars with PM2.5 level
    hjust = 1.2
    ) +
  geom_vline(
    xintercept = 9.0, # adds a vertical line at 9.0ug/m3 to indicate US EPA standard
    linetype = 'dashed',
    linewidth = 1
    ) +
  annotate(
    geom = 'label',
    x = 9, # adds a label to the vertical line below third bar
    y = 0.45,
    hjust = 1.05,
    vjust = 0,
    label= 'EPA standard 9.0 µg/m³',
    fontface = 'bold',
    size = 3,
    label.padding = unit(0.5, 'lines')
    ) +
  labs(
    x = 'PM2.5 level (µg/m³)',
    y = '',
    title = str_glue('Areas in {your_state} with the Highest Air Pollution in 2020'),
    caption = c(
      str_glue('Air pollution can harm health. {pop_exposed}. The percent of people exposed to air pollution in {your_state} is {comparison} compared to the U.S. average ({percent_pop_high_pollution_US$percent_pop}%).',
               pop_exposed = if_else(percent_pop_high_pollution$pop_high_pollution == 0, # adds a different sentence depending on the percent of state population exposed to high air pollution levels
                                     str_glue('About {percent_pop_high_pollution$percent_pop}% of the population in {your_state} live in areas where air pollution is higher than health-based\nstandards (i.e. PM2.5 is ≥9µg/m³)'),
                                     str_glue('About {percent_pop_high_pollution$pop_text} people ({percent_pop_high_pollution$percent_pop}%) in {your_state} live in areas where air pollution is higher than health-based\nstandards (i.e. PM2.5 is ≥9µg/m³)')),
               comparison = case_when( # specifies whether state percent is HIGH or LOW compared to the US average
                 percent_pop_high_pollution$percent_pop > percent_pop_high_pollution_US$percent_pop ~ 'HIGH',
                 percent_pop_high_pollution$percent_pop < percent_pop_high_pollution_US$percent_pop ~ 'LOW')),
      str_glue('\n\n\n\nPM2.5 are fine particles less than 2.5 micrometers in diameter. When inhaled, they can get deep into our lungs and even into our bloodstream. They can\nlead to various health issues like asthma, premature death, decreased lung function, and more. People with heart or lung diseases, children, older\nadults, minority populations, and low socioeconomic status populations are most vulnerable to exposure to fine particle pollution [1].'),
      str_glue('\n\n\n\n\n\n\n\nData Source: National Environmental Public Health Tracking Network, Data Explorer tool (2020). Accessed on {today()}. https://ephtracking.cdc.gov/DataExplorer/\n[1] United States Environmental Protection Agency. (2024, July 16). Health and Environmental Effects of Particulate Matter (PM).\nAbbreviations: EPA; Environmental Protection Agency, PM; Particulate Matter, µg/m³; micrograms per cubic meter (concentration of fine particles in the air).'))
    ) +
  theme(
    panel.border = element_rect(fill = NA, color = 'black'), 
    plot.caption = element_text(hjust = c(0,0,0), # aligns all three sections in the caption to the left edge of plot
                                    size = c(10,9,8), # keeps first section at font size 10, the next section at size 9, and then the last section at size 8
                                    face = c('bold', 'plain', 'italic'), # first section is in bold, second section is plain text and the final section is italicized
                                    lineheight = c(1.3, 1.3, 1.3))
  )

# Save plot as a PNG file. See "Files" pane for the saved image.
ggsave(str_glue('counties_high_PM25_{your_state}.png'),
       dpi=300,
       height=5,
       width=11)


                


