#### Methow steelhead metadata and sample selection ####
# spring 2022
# ~1600 samples are RADsequenced, but need to decide which to do WGS on

# metadata from Chris
setwd("~/Desktop/Methow_steelhead/BY20")
library(tidyverse)
library(readxl)
library(viridisLite)

Methow_steelhead_BY20 <- read_xlsx(path = "BY20 steelhead data for genetics revised 2-23-22.xlsx",
                                   sheet = "BY20 Compiled data", na = c("","*")) # note tank column is duplicated

Methow_steelhead_BY20$FL <- as.numeric(Methow_steelhead_BY20$FL)
Methow_steelhead_BY20$`48 hr SWC mort` <- ifelse(!is.na(Methow_steelhead_BY20$`48 hr SWC mort`),
                                                 Methow_steelhead_BY20$`48 hr SWC mort`, 0)

# all the treatments
ggplot(Methow_steelhead_BY20, aes(Treatment, as.numeric(FL))) +
  geom_boxplot(aes(fill = `SI text`)) + scale_fill_viridis_d()

# now just the EW & EC treatments
ggplot(Methow_steelhead_BY20 %>% filter(Treatment == "EC" | Treatment == "EW"), 
       aes(Treatment, FL, 
           fill = factor(`SI text`))) +
  geom_boxplot(outlier.size = 0) + 
  scale_fill_viridis_d(begin = 0.3, alpha = 0.5) + 
  geom_point(size = 2.5, aes(fill = factor(`SI text`), group = `SI text`, shape = factor(`48 hr SWC mort`)), 
             position = position_jitterdodge(jitter.width = 0.4, dodge.width = 1), alpha = 0.6) +
  ggtitle("SWC 48 h mortality by treatment and smolt status")


# now just the EW & EC treatments
ggplot(Methow_steelhead_BY20 %>% filter(Treatment == "EC" | Treatment == "EW"), 
       aes(Treatment, FL, 
           fill = factor(`SI text`))) +
  geom_boxplot(outlier.size = 0) + 
  scale_fill_viridis_d(begin = 0.3, alpha = 0.5) + 
  geom_point(size = 2.5, aes(fill = factor(`SI text`), group = `SI text`, shape = factor(`SWC mort 14 day`)), 
             position = position_jitterdodge(jitter.width = 0.4, dodge.width = 1), alpha = 0.6) +
  ggtitle("SWC 14 day mortality by treatment and smolt status")


# now just the EW & EC treatments
ggplot(Methow_steelhead_BY20 %>% 
         filter(Treatment == "EC" | Treatment == "EW") %>%
         filter(`SI text` != "NA"), 
       aes(factor(`SI text`), FL, fill = Treatment)) +
  geom_boxplot(outlier.size = 0) + 
  scale_fill_viridis_d(begin = 0.3, alpha = 0.5) + 
  geom_point(size = 2.5, aes(fill = factor(Treatment), group = Treatment, shape = factor(`SWC mort 14 day`)), 
             position = position_jitterdodge(jitter.width = 0.6, dodge.width = 1), alpha = 0.6) +
  ggtitle("SWC 14 day mortality by treatment and smolt status")

ggplot(Methow_steelhead_BY20 %>% 
         filter(Treatment == "EC" | Treatment == "EW") %>%
         filter(`SI text` != "NA"), 
       aes(factor(`SI text`), FL, fill = Treatment)) +
  geom_boxplot(outlier.size = 0) + 
  scale_fill_viridis_d(begin = 0.3, alpha = 0.5) + 
  geom_point(size = 2, aes(fill = factor(Treatment), group = Treatment, shape = factor(`SWC mort 14 day`)), 
             position = position_jitterdodge(jitter.width = 0.8, dodge.width = 1), alpha = 0.6) +
  ggtitle("SWC 14 day mortality by treatment and smolt status")


ggplot(Methow_steelhead_BY20 %>% 
         filter(Treatment == "EC" | Treatment == "EW") %>%
         filter(`SI text` != "NA") %>%
         filter(`SI text` == "Smolt"), 
       aes(factor(`SI text`), FL, fill = Treatment)) +
  geom_boxplot(outlier.size = 0) + 
  scale_fill_viridis_d(begin = 0.6, end = 0.8, option = "inferno") +
  geom_point(size = 3, aes(fill = factor(Treatment), group = Treatment, shape = factor(`SWC mort 14 day`),
                           col = factor(`SWC mort 14 day`)), 
             position = position_jitterdodge(jitter.width = 0.8, dodge.width = 1), alpha = 0.6) +
  scale_color_viridis_d(begin = 0.1, end = 0.6, alpha = 0.5) + 
  ggtitle("SWC 14 day mortality by treatment -- SMOLTS only")

Methow_steelhead_BY20 %>% 
  filter(Treatment == "EC" | Treatment == "EW") %>%
  filter(`SI text` != "NA") %>%
  filter(`SI text` == "Smolt") %>%
  group_by(Treatment, `SWC mort 14 day`, Tank...7) %>%
  count(n())

Methow_EC_EW_bySI_index <- Methow_steelhead_BY20 %>% 
  filter(Treatment == "EC" | Treatment == "EW") %>%
  filter(`SI text` != "NA") %>%
  group_by(`SI text`, Treatment, `SWC mort 14 day`, Tank...7) %>%
  count(n())

Methow_alltreatments_bySI_index <- Methow_steelhead_BY20 %>% 
  filter(`SI text` != "NA") %>%
  group_by(`SI text`, Treatment, Tank...7, `48 hr SWC mort`) %>%
  count(n())

Methow_LCandEC_bySI_index <- Methow_steelhead_BY20 %>% 
  filter(Treatment == "EC" | Treatment == "LC") %>%
  filter(`SI text` != "NA" & `SI text` != "Transitional") %>%
  group_by(`SI text`, Treatment, `SWC mort 14 day`, Tank...7) %>%
  count(n())

# now subsample 30 from within the died and survived groups for smolt and parr
# within each of the EC and LC treatments

# first generate a plot of the EC and LC treatments now that we've changed our minds
ggplot(Methow_steelhead_BY20 %>% filter(Treatment == "EC" | Treatment == "LC"), 
       aes(Treatment, FL, 
           fill = factor(`SI text`))) +
  geom_boxplot(outlier.size = 0) + 
  scale_fill_viridis_d(begin = 0.3, alpha = 0.5) + 
  geom_point(size = 2.5, aes(fill = factor(`SI text`), group = `SI text`, shape = factor(`SWC mort 14 day`)), 
             position = position_jitterdodge(jitter.width = 0.4, dodge.width = 1), alpha = 0.6) +
  ggtitle("SWC 14 day mortality by treatment and smolt status, EC & LC only")

# then subsample the individuals to cherry pick
Methow_WGStosample_ECandLC <- Methow_steelhead_BY20 %>% 
  filter(Treatment == "EC" | Treatment == "LC") %>%
  filter(`SI text` != "NA" & `SI text` != "Transitional") %>%
  group_by(`SI text`, Treatment, `SWC mort 14 day`) %>%
  slice_sample(n = 38) # accounts for smaller than ~30/group in the smaller groups

# plot the subsample
ggplot(Methow_WGStosample_ECandLC, aes(Treatment, FL, 
           fill = factor(`SI text`))) +
  geom_boxplot(outlier.size = 0) + 
  scale_fill_viridis_d(begin = 0.3, alpha = 0.5) + 
  geom_point(size = 2.5, aes(fill = factor(`SI text`), group = `SI text`, shape = factor(`SWC mort 14 day`)), 
             position = position_jitterdodge(jitter.width = 0.4, dodge.width = 1), alpha = 0.6) +
  ggtitle("SWC 14 day mortality by treatment and smolt status, EC & LC only -- SAMPLES SELECTED")

# summarize the sample numbers
Methow_WGStosample_ECandLC_summary <- Methow_WGStosample_ECandLC %>%
  group_by(`SI text`, Treatment, `SWC mort 14 day`) %>%
  count() # accounts for smaller than ~30/group in the smaller groups

write_tsv(Methow_WGStosample_ECandLC, file = "Methow_WGStosample_ECandLC.tsv")
