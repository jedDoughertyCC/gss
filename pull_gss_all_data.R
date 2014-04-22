# analyze survey data for free (http://asdfree.com) with the r language
# general social survey
# replication of tables published by the berkeley survey documentation and analysis
# using 1972-2010 cross-sectional cumulative data (release 2, feb. 2012)

# # # # # # # # # # # # # # # # #
# # block of code to run this # #
# # # # # # # # # # # # # # # # #
# library(downloader)
# setwd( "C:/My Directory/GSS/" )
# source_url( "https://raw.github.com/ajdamico/usgsd/master/General%20Social%20Survey/replicate%20berkeley%20sda.R" , prompt = FALSE , echo = TRUE )
# # # # # # # # # # # # # # #
# # end of auto-run block # #
# # # # # # # # # # # # # # #

# the main norc gss website - http://norc.org/gss+website - directs analysts wishing to generate statistics to
# the berkeley survey documentation and analysis project at http://sda.berkeley.edu
# since quick tables currently available on their website use the release #1 version of the gss data,
# analysts at sda created release #2-specific tables to be matched, available as a pdf here:
# https://github.com/ajdamico/usgsd/blob/master/General%20Social%20Survey/GSS%201972-2010%20Polviews%20by%20Sex%20from%20Berkeley%20SDA.pdf?raw=true

# note that these statistics come very close to the quick table results available at
# http://sda.berkeley.edu/quicktables/quicksetoptions.do?reportKey=gss10%3A0
# however, because berkeley sda currently defaults to release #1 (outdated data)
# sda cannot currently compute the latest statistics


# this r script will replicate each of the statistics from the custom gss run exactly
# https://github.com/ajdamico/usgsd/blob/master/General%20Social%20Survey/GSS%201972-2010%20Polviews%20by%20Sex%20from%20Berkeley%20SDA.pdf?raw=true


# if you have never used the r language before,
# watch this two minute video i made outlining
# how to run this script from start to finish
# http://www.screenr.com/Zpd8

# anthony joseph damico
# ajdamico@gmail.com

# if you use this script for a project, please send me a note
# it's always nice to hear about how people are using this stuff

# for further reading on cross-package comparisons, see:
# http://journal.r-project.org/archive/2009-2/RJournal_2009-2_Damico.pdf


##################################################################################################################
# Analyze the 1972-2010 General Social Survey cross-sectional cumulative data (release 2, feb. 2012) file with R #
##################################################################################################################


# set your working directory.
# all GSS data files will be stored here
# after downloading and importing.
# use forward slashes instead of back slashes

# uncomment this line by removing the `#` at the front..
# setwd( "C:/My Directory/GSS/" )
# ..in order to set your current working directory



# set the number of digits shown in all output

options( digits = 8 )


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# warning: old versions of the survey package will not work.  #
# this script depends on version 3.29 of the survey package.  #
# if typing the command                                       #
# sessionInfo()
# reveals you are using a version of survey lower than 3.29   #
# simply re-install the survey package by running the         #
# install.packages line below.                                #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# remove the # in order to run this install.packages line only once
# install.packages( "survey" , "downloader" )


library(foreign) # load foreign package (converts data files into R)
library(survey)  # load survey package (analyzes complex design surveys)


# by default, R will crash if a primary sampling unit (psu) has a single observation
# set R to produce conservative standard errors instead of crashing
# http://faculty.washington.edu/tlumley/survey/exmample-lonely.html
# by uncommenting this line:
# options( survey.lonely.psu = "adjust" )
# this setting matches the MISSUNIT option in SUDAAN



###############################################
# DATA LOADING COMPONENT - ONLY RUN THIS ONCE #
###############################################

# create new character variables containing the full filepath of the file on norc's website
# that needs to be downloaded and imported into r for analysis
# GSS.2010.CS.file.location <-
  # "http://publicdata.norc.org:41000/gss/documents//OTHR/gss7210_r2b_stata.zip"
  

# create a temporary file and a temporary directory
# for downloading file to the local drive
# tf <- tempfile() ; td <- tempdir()


# download the file using the filepath specified
# download.file( 
  # # download the file stored in the location designated above
  # GSS.2010.CS.file.location ,
  # # save the file as the temporary file assigned above
  # tf , 
  # # download this as a binary file type
  # mode = "wb"
# )


# the variable 'tf' now contains the full file path on the local computer to the specified file

# store the file path on the local disk to the extracted file (previously inside the zipped file)
# inside a new character string object 'fn'
# fn <- 
  # unzip( 
    # # unzip the contents of the temporary file
    # tf , 
    # # ..into the the temporary directory (also assigned above)
    # exdir = td , 
    # # overwrite the contents of the temporary directory
    # # in case there's anything already in there
    # overwrite = T
  # )

# print the temporary location of the stata (.dta) file to the screen
# print( fn )
  

# these two steps take a while.  but once saved as a .rda, future loading becomes fast forever after #


# convert the stata (.dta) file saved on the local disk (at 'fn') into an r data frame
# GSS.2010.CS.df <- read.dta( fn )

  
# save the cross-sectional cumulative gss r data frame inside an r data file (.rda)
# save( GSS.2010.CS.df , file = "GSS.2010.CS.rda" )

# note that this .rda file will be stored in the local directory specified
# with the setwd command at the beginning of the script

##########################################################################
# END OF DATA LOADING COMPONENT - DO NOT RUN DATA LOADING COMMANDS AGAIN #
##########################################################################


# now the r data frame can be loaded directly
# from your local hard drive.  this is much faster.
load( "GSS.2010.CS.rda" )


# display the number of rows in the cross-sectional cumulative data set
nrow( GSS.2010.CS.df )

# display the first six records in the cross-sectional cumulative data set
head( GSS.2010.CS.df )
# note that the data frame contains far too many variables to be viewed conveniently

# create a character vector that will be used to
# limit the file to only the variables needed
KeepVars <-
  c( 
    "relig" ,   # religious preference    

    "relig16" ,     # in what religion were you raised

    "age" ,    # age when surveyed

    "year" , # year of survey
    
    "educ" ,   # highest grade
    
    "income" ,     # income group
    
    "wwwhr",       # hours spent on the web

    "oversamp", "formwt","wtssall" #weights for calculating compwt


  )


# limit the r data frame (GSS.2010.CS.df) containing all variables
# to a severely-restricted r data frame containing only the seven variables
# specified in character vector 'KeepVars'
x <- GSS.2010.CS.df[ , KeepVars ]

# to free up RAM, remove the full r data frame
rm( GSS.2010.CS.df )

# garbage collection: clear up RAM
gc()


# calculate the compwt and samplerc variables
# to match SDA specifications
x <- 
  transform( 
    x , 
    
    # the calculation for compwt comes from
    # http://sda.berkeley.edu/D3/GSS10/Doc/gs100195.htm#COMPWT
    compwt =  oversamp  *  formwt * wtssall)
    
    # # the calculation for samplerc comes from
    # # http://sda.berkeley.edu/D3/GSS10/Doc/gs100195.htm#SAMPLERC
    # samplerc = 
      # # if sample is a three or a four, samplerc should be a three
      # ifelse( sample %in% 3:4 , 3 , 
      # # if sample is a six or a seven, samplerc should be a six
      # ifelse( sample %in% 6:7 , 6 , 
      # # otherwise, samplerc should just be set to sample
        # sample ) )

x <- na.omit(x)


#sets religion
x$has_relig <- 0
x[x$relig != "none",]$has_relig <- 1

#had religion
x$had_relig <- 0
x[x$relig16 != "none",]$had_relig <- 1

#in top income set
x$top75_income <- 0
x[x$income == "$25000 or more",]$top75_income <- 1

#subtracts 1960 from year respondent was born
x$born_from_1960 <- x$year - x$age - 1960

#subtracts 12 from number of years completed
#0 gives hs grad
#4 gives college grad
x$educ_from_12 <- x$educ - 12

#more thant 2 hours of internet a week
x$www2 <- 0
x[x$wwwhr >= 2,]$www2 <- 1


#more thant 2 hours of internet a week
x$www7 <- 0
x[x$wwwhr >= 7,]$www7 <- 1

logit <- glm(has_relig~had_relig+top75_income+born_from_1960+educ_from_12+www7+www2,
    family = "binomial", data = x,weights = x$compwt)

logit2 <- glm(has_relig~top75_income+born_from_1960+educ_from_12+www7+www2,
    family = "binomial", data = y,weights = y$compwt)
summary(logit)

exp(cbind(OR = coef(logit), confint(logit)))

new_data <- with(x,data.frame(born_from_1960,educ_from_12,top75_income,had_relig, www2 = 0, www7 = 0))

new_data$rel_prob <- predict(logit, newdata = new_data, type = "response")


new_data$rel_results <- 0
new_data[new_data$rel_prob >= .5,]$rel_results <- 1
