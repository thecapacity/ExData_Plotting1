library("data.table")

#Getting Data if it doesn't exist
if (! file.exists("data")) {
    dir.create("data")   
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", mode="wb", destfile="./data/data.zip")    
    unzip("./data/data.zip")
    dateDownloaded <- date()
}

#Extracting and Loading Data
power_data <- fread("household_power_consumption.txt", na.strings="?", colClasses="character")
power_data$Date <- as.Date(power_data$Date, format="%d/%m/%Y")

#Once $Date is converted we can subset
sub_data <- power_data[power_data$Date=="2007-02-01" | power_data$Date=="2007-02-02"]

#I couldn't get DF set() to work, so this is something of a hack
dt <- paste(as.Date(sub_data$Date), sub_data$Time)
sub_data$Datetime <- as.POSIXct(dt)

#Clean up the workspace: power_data is ~145Mb
rm(power_data)
rm(dt)

#Convert Data to an integer (note just converts these columns, but that's what we're graphing)
sub_data$Sub_metering_1 = as.numeric(sub_data$Sub_metering_1)
sub_data$Sub_metering_2 = as.numeric(sub_data$Sub_metering_2)
sub_data$Sub_metering_3 = as.numeric(sub_data$Sub_metering_3)

#Output graph to file
png(filename = "plot3.png", width=480, height=480, units="px", bg="white") #bg="transparent")

plot(sub_data$Sub_metering_1 ~ sub_data$Datetime, type="n", ylab="Energy sub metering", xlab="")
lines(sub_data$Sub_metering_1 ~ sub_data$Datetime, col = "Black")
lines(sub_data$Sub_metering_2 ~ sub_data$Datetime, col = "Red")
lines(sub_data$Sub_metering_3 ~ sub_data$Datetime, col = "Blue")
legend(x="topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("Black","Red","Blue"), lwd = 1)

#Close device
dev.off()
