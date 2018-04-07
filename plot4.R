# Download zip
file <- "exdata-data-household_power_consumption.zip"
if (!file.exists(file)) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", file, method="curl")
}

# Create data frame with the data of 1/2/2007 and 2/2/2007 only
file <- unz(file, unzip(file, list=TRUE)[1, "Name"])
data <- grep("^[1|2]/2/2007", readLines(file), value=TRUE)
data <- read.csv2(text=data, header=FALSE, colClasses="character", na.strings="?")
names(data) <- unname(unlist(read.csv2(file, header=FALSE, nrow=1)))

# Convert dates
data$Date <- as.Date(data$Date,"%d/%m/%Y")
data <- data[data$Date == '2007-02-01' | data$Date == '2007-02-02',]
data <- cbind(data, DateTime = strptime(paste(data$Date, data$Time),"%Y-%m-%d %H:%M:%S"))

# Plot and save to png file
png("plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2, 2))
# row1 col1
plot(data$DateTime, data$Global_active_power, type = 'l', xlab = "", ylab = "Global Active Power")
# row1 col2
plot(data$DateTime, data$Voltage, type = 'l', xlab = "datetime", ylab = "Voltage")
# row2 col1
plot(data$DateTime, data$Sub_metering_1, type = 'l', xlab = "", ylab = "Energy sub metering")
lines(data$DateTime, data$Sub_metering_2, col = "red", xlab = "", ylab = "Energy sub metering")
lines(data$DateTime, data$Sub_metering_3, col = "blue", xlab = "", ylab = "Energy sub metering")
legend("topright", legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
       col = c('black', 'red', 'blue'), lwd = 1)
# row2 col2
plot(data$DateTime, data$Global_reactive_power, type = 'l', xlab = "datetime", ylab = "Global_reactive_power")
dev.off()