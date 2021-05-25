# Written by K. Garner, 2020
# plot CNR data from 7T sequences
rm(list=ls())

# Load packages, source function files and define path variables
library(tidyverse)
library(cowplot)
library(wesanderson)
source("R_rainclouds.R")

# define mask and contrast factors below

# -------------------------------------------------------------------------------------
# Load and tidy data
CNR = read.csv('~/Dropbox/MC-Projects/imaging-value-cert-att/striwp1/TDFASTT-data/tThresh_agg.csv')
CNR$sub <- factor(CNR$sub)
CNR$TR <- factor(CNR$TR)
CNR$roi <- factor(CNR$roi)
CNR$contrast <- factor(CNR$contrast)

# CNR$roi <- CNR$roi %>% recode('1' = 'CN',
#                               '2' = 'FEF',
#                               '3' = 'GPe',
#                               '4' = 'GPi',
#                               '5' = 'IPS',
#                               '6' = 'LOC',
#                               '7' = 'Put', 
#                               '8' = 'STN',
#                                '9' = 'VS') 
CNR$contrast <- CNR$contrast %>%  recode('1' = 'tgtLoc',
                                         '2' = 'cueP',
                                         '3' = 'cueP x tgtLoc',
                                         '5' = 'AValue',
                                         '6' = 'RelValue',
                                         '7' = 'Value',
                                         '9' = 'hand')

CNR <- CNR %>% mutate(roi=factor(roi, levels = c('FEF', 'IPS', 'LOC', 'VS', 'CN', 'Put', 'GPe', 'GPi', 'STN')))



# -------------------------------------------------------------------------------------
# define plotting function
draw.sub.plts <- function(data, C){
  
  data %>% filter(contrast == C) %>%
           ggplot(aes(x=TR, y=tT, group=sub)) +
           geom_line(aes(color=sub), lwd=1.1) + facet_wrap(.~roi) +
           scale_colour_manual(values=c(wes_palette("IsleofDogs1"))) +
           ylab("RMS CNR") +
           ggtitle(C) +
           theme_cowplot()
}

lapply(levels(CNR$contrast), function(x) with(CNR[CNR$contrast == x, ], boxplot(tT ~ roi)))
# subs 1 & 3 are outliers in this instance so removing for plots, 4 contributes only zeros

# sub 3 is clearly an outlier in terms of the number of voxels and the t-values 
lapply(levels(CNR$contrast), draw.sub.plts, data=CNR)
lapply(c("tgtLoc", "cueP", "hand"), draw.sub.plts, data=CNR[!CNR$sub %in% c("1","3"),])
# -------------------------------------------------------------------------------------
# analyse subcortical data by contrast
# 1st models compares the TR and ROIs for each contrast (we know ROIs will likely be different but this will help us 
# triangulate where the signal is). The last model collapsed across contrasts (excluding the most obvious one) to see
# if aggregating information across contrasts will help. It did not help.

########### for if stat testing
subcort <- CNR %>% filter(!roi %in% c('FEF', 'IPS', 'LOC'))
sub.mods <- lapply(levels(subcort$contrast), function(x) aov(tT~TR*roi+Error(sub/(TR*roi)), data=subcort[subcort$contrast==x, ]))
# are the results driven by the 1st subject? No, looks like they are made clearer.
sub.mods.d1 <- lapply(levels(subcort$contrast), function(x) aov(R~TR*roi+Error(sub/(TR*roi)), data=subcort[subcort$contrast==x & subcort$sub != "1", ]))
# so will replot without sub 1
lapply(levels(CNR$contrast), draw.sub.plts, data=CNR[CNR$sub != "1",] )

# Following up:
x = c("700", "700", "1510")
y = c("1510", "1920", "1920")
do.ts <- function(data, x, y){
   t.test(data$R[data$TR == x], data$R[data$TR == y], paired=TRUE, var.equal=FALSE)
}
apply.ts <- function(data, sig){
  lapply(levels(data$contrast)[sig], function(c) mapply(do.ts, x, y, MoreArgs=list(data=data[data$contrast == c, ])))
}
sig = c(1, 2, 3, 4, 5, 7)
fucomps <- apply.ts(data=subcort[subcort$sub != "1", ], sig=sig)
# for each comp assess against (1-alpha)^1/3 (Sidak) p < .017
# tgtloc: 700 < 1510, 700 < 1920
# cueP: 700 < 1510, 700 < 1920
# cueP x tgtLoc: 700 < 1510, 700 < 1920
# AValue: 700 < 1510, 700 < 1920
# RelValue: 700 < 1510, 700 < 1920
# hand: 700 > 1920, 1510 > 1920
fucomps.all.ps <- apply.ts(data=subcort, sig=sig)
# results are the same if you include everybody, apart from hand contrasts are nsig

cort <- CNR %>% filter(roi %in% c('FEF', 'IPS', 'LOC'))
cort.mods <- lapply(levels(cort$contrast), function(x) aov(R~TR*roi+Error(sub/(TR*roi)), data=cort[cort$contrast==x, ]))
cort.mods.d1 <- lapply(levels(cort$contrast), function(x) aov(R~TR*roi+Error(sub/(TR*roi)), data=cort[cort$contrast==x & cort$sub != "1", ]))
# not significant after dropping rogue participant. Not following up any further.
                     