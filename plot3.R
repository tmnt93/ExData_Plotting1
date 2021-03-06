# Plot 3 for Exploratory Analysis HW #1

# Set the working directory 
curr_folder<-("C:/coursera/ExploratoryDataAnalysis/hw1")
setwd(curr_folder)
data_folder <-("data")   #subfolder for zip and txt file
zip_file <-("household_power_consumption.zip")
csv_file <-("household_power_consumption.txt")
full_path_zip <-paste(curr_folder,data_folder,zip_file,sep = "/")
full_path_csv <-paste(curr_folder,data_folder,csv_file,sep = "/")

# Determine if the csv file exist
if(!file.exists(full_path_csv)) {
  
    # Set current working directory to data sub folder
    setwd(paste(curr_folder,data_folder,sep = "/"))
    
    # Determine if the zip exist
    if(!file.exists(full_path_zip)) {
        #If Zip file does not exist, download file and store in the data sub folder
        url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        download.file(url,destfile=zip_file)
    } else {
        #If Zip file exist, extra to the data sub folder
        unzip(full_path_zip,overwrite=TRUE)
      }
}
   
#The CSV file exist in the data subfolder. We proceed to read the data
data_all <- read.csv(full_path_csv,header=TRUE,sep =";",na.strings="?",stringsAsFactors=FALSE)
#Convert to date  
data_all$Date <- as.Date(data_all$Date, format="%d/%m/%Y")
#We will only be using data from the dates 2007-02-01 and 2007-02-02.
data <- data_all[data_all$Date=="2007-02-01" | data_all$Date=="2007-02-02",]
#Convert to valid POSIXLT time format. Time column will display both date and time
data$Time <- strptime(paste(data$Date, data$Time, sep=" "),"%Y-%m-%d %H:%M:%S")

# We can check if Time format is correct by performing the following tests
#   class(data$Time)    
#   str(data$Time)
#   data$Time[11] - data$Time[1]
#   data$Time[2] - data$Time[1]
#   data$Time[180] - data$Time[1]
#   data$Time[2880] - data$Time[1]

#Convert the rest of the columns to numerics
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)
data$Voltage <- as.numeric(data$Voltage)
data$Global_intensity <- as.numeric(data$Global_intensity)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# Save Plot in the top level folder
# Add the PNG file and R code file to the top-level folder of your git repository (no need for separate
# sub-folders)
setwd(curr_folder)

#Make a PNG copy of the sub metering plot using Graphic Device
png(filename="plot3.png",width=480, height=480, units='px')

# Create plot of Sub metering over Time and Date
plot(data$Time,data$Sub_metering_1,type="l",col="black",ylab="Energy sub metering",xlab="") 
lines(data$Time,data$Sub_metering_2,type="l",col="red")
lines(data$Time,data$Sub_metering_3,type="l",col="blue")

# Legend - Placed top right corner with borders
line_colors<-c('black','red','blue')
line_names<-c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
legend('topright',legend=line_names,col=line_colors,bty="y",lty='solid')

#Turn Graphic Device off
dev.off()