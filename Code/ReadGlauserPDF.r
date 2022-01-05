# read in a pdf format
library(tidyverse)
library(pdftools)

columns <- c("1-zi-mean", "1-zi-low", "1-zi-up", "1-zi-var",
             "2-zi-mean", "2-zi-low", "2-zi-up", "2-zi-var",
             "3-zi-mean", "3-zi-low", "3-zi-up", "3-zi-var",
             "4-zi-mean", "4-zi-low", "4-zi-up", "4-zi-var",
             "5-zi-mean", "5-zi-low", "5-zi-up", "5-zi-var")

# private flat rent prices
liste <- pdf_text("Varia/Data/Glauser.pdf")[38:39]
tmp1 <- unlist(str_split(liste[1], "\n")) %>%
  str_replace_all("\\…", "NA") %>%
  str_trim() %>%
  str_replace_all(",", ".") %>%
  as_tibble() %>%
  slice(16:61) %>%
  rename(a = value)
tmp2 <- unlist(str_split(liste[2], "\n")) %>%
  str_replace_all("\\…", "NA") %>%
  str_trim() %>%
  str_replace_all(",", ".") %>%  as_tibble() %>%
  slice(11:56) %>%
  rename(b = value)

qmp_pr <- tmp1 %>% cbind(tmp2) %>%
  mutate(distr = str_extract(a, "(\\w+)( \\d{1,2})?"), .before = 1) %>%
  mutate(a = str_extract(a, "(\\d{1,2}.\\d|NA) .*")) %>%
  mutate(a = str_replace_all(a, "\\s+", ";")) %>%
  mutate(b = str_replace_all(b, "\\s+", ";")) %>%
  separate(a, into = columns[1:12], sep = ";") %>%
  separate(b, into = columns[13:20], sep = ";") %>%
  mutate(across(-distr, as.numeric))

# non-profit flat rent prices
liste <- pdf_text("Varia/Data/Glauser.pdf")[40:41]
tmp1 <- unlist(str_split(liste[1], "\n")) %>%
  str_replace_all("\\…", "NA") %>%
  str_trim() %>%
  str_replace_all(",", ".") %>%
  as_tibble() %>%
  slice(14:59) %>%
  rename(a = value)
tmp2 <- unlist(str_split(liste[2], "\n")) %>%
  str_replace_all("\\…", "NA") %>%
  str_trim() %>%
  str_replace_all(",", ".") %>%  as_tibble() %>%
  slice(11:56) %>%
  rename(b = value)

qmp_ge <- tmp1 %>% cbind(tmp2) %>%
  mutate(distr = str_extract(a, "(\\w+)( \\d{1,2})?"), .before = 1) %>%
  mutate(a = str_extract(a, "(\\d{1,2}.\\d|NA) .*")) %>%
  mutate(a = str_replace_all(a, "\\s+", ";")) %>%
  mutate(b = str_replace_all(b, "\\s+", ";")) %>%
  separate(a, into = columns[1:12], sep = ";") %>%
  separate(b, into = columns[13:20], sep = ";") %>%
  mutate(across(-distr, as.numeric))

write_delim(qmp_pr, "Varia/Output/qmp_privat.csv", delim = ";")
write_delim(qmp_ge, "Varia/Output/qmp_gemeinnuetzig.csv", delim = ";")
