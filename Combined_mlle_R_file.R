####################
#
#   Making Graphs for the combined_mlle_1-8_Ju11 bartender data
#   using ggplot
#   created July 11 2023
#   Last updated: July 24 2023
#
#   Inputs: a combined cluster .csv from bartender (change on line 28). 
#   has 3 parts: a formatter, a line graph and a barplot.
#
#   NOTE: remember to setwd() to source file location: 
#   //wsl.localhost/Ubuntu-20.04/home/daphne13/bartender11
#
####################

#NOTE: DO 1-7 DO 8-15 DO 16-23

install.packages("")
library(ggplot2)
library(data.table)
library(tibble)
library(dplyr)
##########################################################################################
## FORMAT THE CSV FILE TO BE READ BY GGPLOT
## Change the .csv file to be read, LINE 33 to remove top barcodes


#format df, and initialize df1 and df2 and df_large
df <- read.csv("EVERYTHING_R1R2/combined_R1R2_8-15/combined_R1R2_8-15_cluster.csv")
{
  df <- df[-c(2,3)]
  df <- add_column(df, timepoint ="", .after = "Cluster.ID")
  #df <- df[!(row.names(df) %in% c("24","21", "19")),]   ##########################################
  
  i = 1  # this for looop normalizes the columns by the total barcode reads in the column
  for (column in df) {
    if (i > 2) {
      totalnum <- sum(df[i]) 
      df[i] <- as.numeric(unlist(df[i])) / totalnum
    }
    i = i + 1
  }
  colnames(df)[3] <- "two_hours"
  colnames(df)[4] <- "four_hours"
  colnames(df)[5] <- "six_hours"
  colnames(df)[6] <- "eight_hours"
  colnames(df)[7] <- "twenty_four_hours"
  colnames(df)[8] <- "thirty_hours"
  colnames(df)[9] <- "forty_eight_hours"
  colnames(df)[10] <- "seventy_two_hours"
  df1 <- df
  df2 <- df
  df_large <- setNames(data.frame(matrix(ncol = 3, nrow = 0)), 
                       c("Cluster>ID", "timepoint", "bc_count"))
  # turn data frame into 3 columns
  i = 1
  timep_list <- c() #this is to store x axis labels
  for (column in df) {
    if (i > 2) {
      df1$timepoint <- colnames(df)[i]
      timep_list <- append(timep_list,colnames(df)[i])
      df2 <- df1[-c(3)] #df2 is whole df minus the tp we recorded
      df1 <- df1[c(1,2,3)]
      colnames(df1)[3] <- "bc_count"
      #append df 1 to larger data frame
      df_large <- rbind(df_large, df1)
      df1 <- df2
    }
    i = i + 1
  }
}

##########################################################################################
## LINE GRAPH OF ALL BARCODES CHANGING THROUGH TIME ##
## Change graph labels (line 87), Change name of pdf output file (line 73)

### GRAPH OF July 7 barcodes 1-8 all barcodes vs time


pdf("R1R2_16-23_linesJul24.pdf")
{
 tp <- df_large[nrow(df_large), 2]
  print(ggplot(data=df_large, aes(timepoint, bc_count, group=Cluster.ID)) +
  geom_line(aes(col = Cluster.ID))+
  scale_x_discrete(limits = timep_list) +
  scale_y_continuous(trans='log10') +     
  scale_colour_gradientn(colours = 
            c("red", "yellow","green","lightblue","blue","purple"),
            values = c(1.0, 0.8, 0.6, 0.4, 0.2, 0.1, 0)) +
  geom_label(aes(label = Cluster.ID),
            data = filter(df_large, df_large$timepoint == tp),
            size = 2)+
  theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust=1))+
  labs(title="Beads only barcodes, Time vs Barcode Count", 
            subtitle="All barcodes vs time: combined_R1R2_8-15",
            x ="Time Point (hr) ", y = "Barcode Count"))
dev.off()
}

# CLOSE UP OF PREVIOUS GRAPH (just to check work)
{ 
  ggplot(data=df_large, aes(timepoint, bc_count, group=Cluster.ID)) +
  geom_line(aes(col = Cluster.ID))+
  scale_x_discrete(limits = timep_list) +
  scale_colour_gradientn(colours = 
             c("red", "yellow","green","lightblue","blue","purple"),
             values = c(1.0, 0.8, 0.6, 0.4, 0.2, 0.1, 0)) +
  geom_label(aes(label = Cluster.ID),
             data = filter(df_large, df_large$timepoint == "time_point_7"),
             size = 3)+
  theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust=1))+
  labs(title="CLOSE UP July 7 barcodes 1-8", 
       subtitle="Time vs Barcode Count: combined_mlle_16-23_Ju11",
       x ="Time Point (hr) ", y = "Barcode Count")+
  ylim(0, 50)
}


######################################################################################################
## BAR PLOT AT ONE TIMEPOINT (just to check work) ## 
## Change bar_timepoint to the time you want to graph, Change labs

#set what timepoint you want for the graph

bar_timepoint <- df$time_point_1

  ggplot(df, aes(x = reorder(Cluster.ID, -bar_timepoint), y = bar_timepoint, fill = Cluster.ID)) + 
    geom_bar(stat = "identity") +
    scale_fill_continuous(type = "viridis") +
    labs(title="BARPLOT Barcode counts at TIME 1", 
       subtitle="barcode counts at time_point_1: combined_mlle_1-7_Ju11",
       x ="Clusters by Name ", y = "Barcode Frequency") +
    theme_grey(base_size = 6)
  
######################################################################################################
## BAR PLOTS OF ALL TIMEPOINTS ##
## Change name of pdf output file (line 132)
 
pdf("R1R2_8-15_final_barsJul24.pdf", width = 15, height = 6)
{
  df_ordered <- df %>% arrange(desc(two_hours))
  cluster_order <- as.character(df_ordered$Cluster.ID)
  
  i = 1
  for (column in df) {
    if (i > 2) {
      bar_timepoint <- colnames(df)[i]
      print(ggplot(df, aes(x = factor(Cluster.ID, level = cluster_order), y = column, fill = column)) + 
              ylim(0,1.0) + 
              geom_bar(stat = "identity") +
              scale_fill_gradientn(colours = 
                                       c("red", "orange", "yellow"),
                                     values = c(0.0001, 0.01, 1)) +
              labs(title = "Planktonic experiment WITHOUT top 3 barcodes: Frequencies at time: ", subtitle = bar_timepoint,
                   x ="Clusters by Name ", y = "Barcode Frequency")) +
        theme_grey(base_size = 6)
      
    }
    i = i + 1
  }
  dev.off()
}
