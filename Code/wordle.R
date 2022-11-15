#Some stuff to facilitate word finding for the wordle game
#(https://www.powerlanguage.co.uk/wordle/)


# functions and libraries ---------------------------------------------------------------------

library(wordle)
#(mainly for the word list which is contained in wordle_dict)
library(tidyverse)
library(tm)

#function which reduces the dictionary to the possible words based on
#characters sure to exclude and include plus the found positions in
#positive and negative sense (positive: letter is at certain position,
#negative: letter is in word but not at certain position).
reduce <- function(exclude, include, positions_pos, positions_neg, dict = wordle_dict) {
  exclude <- paste0("[^", exclude, "]{5}")
  positions <- ifelse(positions_neg != "", paste0("[^", positions_neg, "]"), ".")
  positions <- ifelse(positions_pos != "", positions_pos, positions)
  positions <- paste(positions, collapse = "")
  
  for (i in 1:nchar(include)) {
    if (i == 1) 
      index <- grepl(substr(include, i, i), dict, perl = TRUE) else
        index <- index & grepl(substr(include, i, i), dict, perl = TRUE)
  }
  
  index <- index &
    grepl(exclude, dict, perl = TRUE) &
    grepl(positions, dict, perl = TRUE)
  
  dict[index]
}

#function to return the next most probable words from a certain dictionary
#based on the most frequent letters. nmax indicates how many of the next
#frequent letters should be respected. Include is a string with the included
#letters.
select_probable <- function(dict=wordle_dict, include="") {
  dict <- removePunctuation(dict)
  
  freqs <- dict %>% 
    paste(collapse="") %>% 
    strsplit(split="") %>%
    unlist %>%
    table %>%
    as_tibble() %>%
    rename(freq = n, letter = '.') %>%
    arrange(desc(freq))
  
  if (nchar(include) > 0) {
    freqs <- freqs %>%
      filter(!map_lgl(letter, function(x) grepl(x, include)))
  }
  
  if (nrow(freqs) == 0) {
    return(dict)
  }

  newdict = c()
  while (length(newdict) == 0) {  
    for (i in 1:nrow(freqs)) {
      if (i == 1)
        index <- grepl(freqs$letter[i], dict) else
          index <- index & grepl(freqs$letter[i], dict)
    }
    
    newdict <- dict[index]
    freqs <- head(freqs, nrow(freqs)-1)
  }
  
  newdict
}

#wrapper
get_next <- function(exclude, include, positions_pos, positions_neg, dict=wordle_dict) {
  newdict <- reduce(exclude, include, positions_pos, positions_neg, dict)
  select_probable(newdict, include)
}

# running the code ----------------------------------------------------------------------------

#starting word
#random but containing a, e and s
wordle_dict[sample(grep(".*(a(?=.*e(?=.*s.*).*)|e(?=.*a(?=.*s.*).*)|s(?=.*a(?=.*e.*).*))",
                        wordle_dict, perl = TRUE), 1)]
# (maybe best starting word is aeros? arose?)
# 
# or via the above funcion
select_probable()

#check possible solutions
excl <- ""
incl <- ""
pos <- c("", "", "", "", "")
neg <- c("", "", "", "", "")
get_next(excl, incl, pos, neg)

# manual tests
newwordle <- reduce(excl, incl, pos, neg)
length(newwordle)
select_probable(newwordle, incl)
