#Regular Expressions Every R programmer Should Know

library("stringr")
# We’re going to use the str_detect() and str_subset() functions. In particular the latter. These have the syntax

# function_name(STRING, REGEX_PATTERN)
# str_detect() is used to detect whether a string contains a certain pattern. At the most basic use of these functions, we can match strings of text. For instance

jr = c("Theo is first", "Esther is second", "Colin - third")
str_detect(jr, "Theo")
str_detect(jr, "is")
# So str_detect() will return TRUE when the element contains the pattern we searched for.
#If we want to return the actual strings that contain these patterns, we use str_subset()

str_subset(jr, "Theo")
str_subset(jr, "is")
# To practise our regex, we’ll need some text to practise on. Here we have a vector of filenames called files

files = c(
  "tmp-project.csv", "project.csv", 
  "project2-csv-specs.csv", "project2.csv2.specs.xlsx", 
  "project_cars.ods", "project-houses.csv", 
  "Project_Trees.csv","project-cars.R",
  "project-houses.r", "project-final.xls", 
  "Project-final2.xlsx",  "anyProject_Trees.csv"
)
# I’m also going to give us a task. The task is to be able to grab the files that have a format “project-objects”
#or “project_objects”. Let’s say of those files we want the csv and ods files. i.e. we want to grab the files
#“project_cars.ods”, “project-houses.csv” and “project_Trees.csv”.
#As we introduce more regex we’ll gradually tackle our task.

# Regex: The backslash, \
# Here we go! Our first regular expression. When typing regular expressions,
# there are a group of special characters called metacharacters that have other functions. These are:
  
# .{()\^$|?*+
# The backslash is SUPER important because if we want to search for any of these characters
# without using their built in function we must escape the character with a backslash.
#For example, if we wanted to extract the names of the name of all csv files then perhaps we would think
#to search for the string “.csv”? Then we would do
    
str_subset(files, "\.csv")
# Hang on a second, what? Ah yes. The backslash is a metacharacter too!
#So to create a backslash for the function to search with, we need to escape the backslash!

str_subset(files, "\\.csv")
# Much better. With regards to our task, this is already useful, as we want csv and ods files.
# However, you’ll notice when we searched for files contained the string “.csv”,
#we got files of type “.xlsx” as well, just because they had “.csv” somewhere in their name or extension.
#Up step the hat and dollar…

# Regex: The hat ,^, and dollar, $
# The hat and dollar are used to specify the start and end of a line respectively.
# For instance, all file names that start with “Proj” (take note of the capital “P”!)

str_subset(files, "^Proj")
# So what if we wanted specifically just “.csv” or “.ods” files, just like in our task?
# We could use the dollar to search for files ending in a specific extension

str_subset(files, "\\.csv$")
str_subset(files, "\\.ods$")
# Now we can search for files that end in certain patterns. That’s all well and good,
# but we still can’t search for both together. Up step round parentheses and the pipe…

# Regex: Round parentheses,(), and the pipe, |
# Round parentheses and the pipe are best used in conjuction with either other.
# The parentheses specify a group and the pipe means “or”. Now, we could search for files
# ending in a certain extension or another extension. For our task we need “.csv” and “.ods” files. Using the pipe

str_subset(files, "\\.csv$|\\.ods$")
# Alternatively we can use a group and pipe
str_subset(files, "\\.(csv|ods)$")
# Now we don’t have to write surrounding expressions more than once.
# Of course there are other csv and ods files that we don’t want to collect.
# Now we need a way of specifiying a block of letters. Up step the square parentheses and the asterisk…

# Regex: Square parentheses,[], and the asterisk, *
# The square parentheses and asterisk. We can match a group of characters or digits using the square parentheses.
# Here I’m going to use a new function, str_extract(). This does as it says on the tin,
# it extracts the parts of the text that match our pattern. For instance the last lower case letter
# in each element of the vector, if such a thing exists

str_extract(files, "[a-z]$")
# Notice that one of the files ends with an upper case letter, so we get an NA. To include this we add “A-Z”
# (to add numbers we add 0-9 and to add metacharacters we write them without escaping them)

str_extract(files, "[a-zA-Z]$")
# Now, this is obviously useless at the moment. This is where does the asterisk comes into it.
# The asterisk is what is called a quantifier.There are three other quantifiers (+, ? and {}),
# but won’t cover them here. A quantifier quantifies how many of the characters we want to match
# and the asterisk means we want 0 or more characters of the same form. For instance, we could now
# extract all of the file extensions if we wished to

str_extract(files, ".[a-zA-Z]*$")
# So we go backwards from the end of the line collecting all the characters until we hit a character
# that isn’t a lower or upper case letter. We can now use this to grab the group letters preceeding
# the file extensions for our task

str_subset(files, "[a-zA-Z]*.(csv|ods)$")
# Obviously we still have some pesky files in there that we don’t want. Up step the… only joking!
# We now actually have all the tools to complete the task. The filenames we want take the form
# project-objects or project_objects, so we know that preceeding that block of letters for “objects”
# we want either a dash or an underscore. We can use a group and pipe for this

str_subset(files, "(_|-)[a-zA-Z]*.(csv|ods)$")
# We still have two pesky files sneaking in there. How do those two files and the three files we want differ?
# Well the files we want all start with “project-” or “project_” where as the other two don’t
#We must also take note that the project could have a capital “P”. We can combat that using a group!

str_subset(files, "(P|p)roject(_|-)[a-zA-Z]*.(csv|ods)$")
# If we had a huge file list, we’d want to stop files such as “2Project_Trees.csv” filtering in as well.
# So we can just use the hat to specify the start of a line

str_subset(files, "^(P|p)roject(_|-)[a-zA-Z]*.(csv|ods)$")
