# load libraries
library(tidyverse)
library(xtable)

# generate table
tf <- read_rds('data/tf.rds')
mir <- read_rds('data/mir.rds')

names(tf)[1] <- 'tr' 
names(mir)[1] <- 'tr' 

bind_rows(list(TF = tf, miRNA = mir), .id = 'type') %>%
  select(-study) %>%
  arrange(type, tr) %>%
  mutate(type = ifelse(duplicated(type), '', type),
         tr = ifelse(duplicated(tr), '', tr)) %>%
  setNames(c('Type', 'Transcriptional Regulator', 'Target', 'Correlation')) %>%
  xtable(caption = 'Output of transcription regulators from cRegulome.',
         align = 'cllll',
         label = 'tab:output') %>%
  print(include.rownames = FALSE,
        booktabs = TRUE,
        add.to.row = list(pos = list(16, 6, 13, 18),
                          command = c('\\midrule ', rep('\\cmidrule{2-4} ', 3))),
        caption.placement = 'top',
        table.placement = 'H',
        sanitize.text.function = identity,
        comment = FALSE,
        file = paste('manuscript/tables', 'output.tex', sep = '/'))
