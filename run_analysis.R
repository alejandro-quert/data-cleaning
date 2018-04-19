course_project <- function()
{
	
	#Download and unzip data. 
	#If you are running this script more than once, you can comment the following four lines after the first time.
	print("Downloading data...")
	#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";	
	#download.file(fileUrl, destfile = "data.zip");	
	#unzip("data.zip");
	
	#Reading test and train data as tables. 
	print("Reading measures...")
	train_data <- read.table("UCI HAR Dataset/train/X_train.txt");
	test_data <- read.table("UCI HAR Dataset/test/X_test.txt");
	
	#Reading test and train activities as tables. 
	print("Reading activities...")
	train_activities <- read.table("UCI HAR Dataset/train/y_train.txt");
	test_activities <- read.table("UCI HAR Dataset/test/y_test.txt");
	
	#Reading test and train subjects as tables. 
	print("Reading subject ids...")
	train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt");
	test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt");
	
	#Converting train and test subjects to vectors.
	print("Vectorizing subject ids...")
	train_subjects <- as.integer(train_subjects$V1);
	test_subjects <- as.integer(test_subjects$V1);
	
	#Reading activity labels as table.
	print("Reading activity labels...")
	activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt");
	
	print("Replacing activity ids by labels...")
	
	#Replacing train activities numeric values by labels and store them in a vector.	
	train_activities_labeled <- as.character(factor(c(train_activities$V1), levels = activity_labels[,1], labels = activity_labels[,2]));
	
	#Replacing test activities numeric values by labels and store them in a vector.
	test_activities_labeled <- as.character(factor(c(test_activities$V1), levels = activity_labels[,1], labels = activity_labels[,2]));
	
	#Reading measure column names as table.
	print("REading column names...");
	measure_columns <- read.table("UCI HAR Dataset/features.txt");	
	
	#Getting mean() and std() columns.
	print("Getting mean() and std() columns...");
	mean_columns <- subset(measure_columns, grepl(pattern = "mean()" , x = measure_columns$V2, fixed = TRUE));	
	std_columns <- subset(measure_columns, grepl(pattern = "std()" , x = measure_columns$V2, fixed = TRUE));
	
	#Store mean() and std() column names in vectors.
	mean_columns <- as.character(mean_columns$V2);
	std_columns <- as.character(std_columns$V2);	

	#Merge mean() and std() column names in a single vector.
	print("Merge mean() and std() column names in a single vector...");
	filter_columns <- c(mean_columns, std_columns, c("activity", "user"));
	
	#Store measure column names as vector.
	measure_columns <- as.character(measure_columns$V2);
	
	#Create the big data frame structure, with measure columns, plus user and activity columns.
	columns <- c(measure_columns, c("activity", "user"));	
	big_data_frame <- data.frame(matrix(ncol = length(columns), nrow = 0));
	colnames(big_data_frame) <- columns;
	
	print("Merging train and test data in a single data frame...");
	
	#Put al train data into a single data frame.
	train_data_frame <- as.data.frame.matrix(train_data);
	train_data_frame <- cbind(train_data_frame, train_activities_labeled);
	train_data_frame <- cbind(train_data_frame, train_subjects);
	colnames(train_data_frame) <- columns;
	
	#Put al test data into a single data frame.
	test_data_frame <- as.data.frame.matrix(test_data);
	test_data_frame <- cbind(test_data_frame, test_activities_labeled);
	test_data_frame <- cbind(test_data_frame, test_subjects);
	colnames(test_data_frame) <- columns;
	
	#Combined test and train data...finally
	big_data_frame <- rbind(big_data_frame, train_data_frame);
	big_data_frame <- rbind(big_data_frame, test_data_frame);
	
	print("Subseting by mean() and std() columns...");
	
	#Selected only mean(), std(), user and activity columns.
	cleaned_data_frame <- subset(big_data_frame, select = filter_columns);
	
	print("Installing reshape2(only if is not installed yet)...");
	
	#Install reshape2 package. If installed already, just making sure to including it with library().
	install.packages("reshape2");
	library("reshape2");
	
	print("Creating tidy dataset...");
	
	#Convert to tidy data. Keeping user and activity columns.
	tidy_data_frame <- melt(cleaned_data_frame, id.vars = c("activity", "user"));
	
	print("Creating result data set...");
	
	#Splitting by user, activity and variable.
	splitted <- split(tidy_data_frame, list(tidy_data_frame$user, tidy_data_frame$activity, tidy_data_frame$variable));
	
	data_list <- lapply(splitted, get_user_df);
	
	observation_count <- length(data_list);
	
	result_data_frame <- data.frame(matrix(ncol = 4, nrow = 0));
	colnames(result_data_frame) <- c("user", "activity", "measure", "mean");
	
	for(i in 1:observation_count)
	{
		result_data_frame <- rbind(result_data_frame, data_list[[i]]);
	}
	
	print("Exporting result data frame to txt...");
	
	write.table(result_data_frame,"tidy_result.txt",sep="\t",row.names=FALSE, col.names=TRUE);
	
	print("Finished...");
}

get_user_df <- function(df)
{
	user <- df[1,2];
	activity <- df[1,1];
	variable <- df[1,3];
	v_mean <- mean(df$value);
	x <- c(as.character(user), as.character(activity), as.character(variable), as.character(v_mean));
	
	data_frame <- data.frame(matrix(ncol = 4, nrow = 0));
	data_frame <- rbind(data_frame, x);
	colnames(data_frame) <- c("user", "activity", "measure", "mean");
	data_frame
}