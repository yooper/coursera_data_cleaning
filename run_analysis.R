
# 2014 Dan Cardin
# Clean student count data from multiple years and merge the data sets into 
# a single data frame, combine county information with the student counts based
# on the school name

# This is system dependent you may need to adjust or comment out
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre8')

# include required libraries
library(xlsx)
library(XML)

# load the raw html info that has school name, city and county
filename = 'raw_district_name_by_city_by_county.xml'
str = readChar(filename, file.info(filename)$size)

xt <- readHTMLTable(str,
                    header = c("District","City","County"),
                    colClasses = c("character","character","character"),
                    trim = TRUE, stringsAsFactors = FALSE)

district_df = as.data.frame(xt)
colnames(district_df) <- c("District","City","County")

# load the individual data sets
fall_2009 = read.csv("fall_2009.csv", header = TRUE, sep = ",", quote = "\"")
fall_2010 = read.xlsx("fall_2010.xls", header=TRUE, sheetName = "K-12 Total Data")
fall_2011 = read.xlsx("fall_2010.xls", header=TRUE, sheetName = "K-12 Total Data")
fall_2012 = read.xlsx("fall_2010.xls", header=TRUE, sheetName = "K-12 Total Data")
fall_2013 = read.xlsx("fall_2010.xls", header=TRUE, sheetName = "K-12 Total Data")

# add identifier to each data frame before we merge
fall_2009$year = 2009
fall_2010$year = 2010
fall_2011$year = 2011
fall_2012$year = 2012
fall_2013$year = 2013

# put all the data into a single data frame
all_data = rbind(fall_2009, fall_2010, fall_2011, fall_2012, fall_2013)

# make the col names nicer to read
colnames(all_data) = c("District Code",
                       "District Name",
                       "K-12 American Indian Male",    		
                       "K-12 Asian Male",				
                       "K-12 African-American Male",				
                       "K-12 Native Hawaiian Male",				
                       "K-12 White Male",				
                       "K-12 Hispanic Male",				
                       "K-12 Multiracial Male",				
                       "K-12 American Indian Female",				
                       "K-12 Asian Female",				
                       "K-12 African-American Female",				
                       "K-12 Native Hawaiian Female",				
                       "K-12 White Female",				
                       "K-12 Hispanic Female",				
                       "K-12 Multiracial Female",				
                       "K-12 Total American Indian",				
                       "K-12 Total Asian",				
                       "K-12 Total African-American",				
                       "K-12 Total Native Hawaiian",				
                       "K-12 Total White",				
                       "K-12 Total Hispanic",				
                       "K-12 Total Multiracial",				
                       "Kindergarten Total Enrollment",				
                       "Grade1 Total Enrollment",				
                       "Grade2 Total Enrollment",				
                       "Grade3 Total Enrollment",				
                       "Grade4 Total Enrollment",				
                       "Grade5 Total Enrollment",				
                       "Grade6 Total Enrollment",				
                       "Grade7 Total Enrollment",				
                       "Grade8 Total Enrollment",				
                       "Grade9 Total Enrollment",				
                       "Grade10 Total Enrollment",				
                       "Grade11 Total Enrollment",				
                       "Grade12 Total Enrollment",				
                       "K-12 Total Male",				
                       "K-12 Total Female",				
                       "K-12 Grand Total Enrollment",
                       "Year"
)
                       
# merge the district name,city, and county data frame with the all data frame
school_districts_tidy = merge(all_data, district_df, by.x = 'District Name', by.y = 'District')

# after the merge there are 889 observations that did not match. Too bad!
 
# write the tidy data to csv
write.table(school_districts_tidy, file = "school_districts_tidy.csv", append = FALSE, quote = TRUE, sep = ",")


