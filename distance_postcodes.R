#Which postcodes in pimlico are farthest away from the store

#distance of each postcode from the store.


library(rjson)

library(gmapsdistance)

API_key <- "AIzaSyAQND4Ah_R-5lLbuBQQLCVeNkm82c9xZ9k"

#Read the pimplico postcodes
user_dt <- read.csv("../data/Pimlico_Postcode.csv")

#Read the store location for pimlico
store_loc <- fromJSON(file = "../data/pimlico_store_location.json")
location <- store_loc$results[[1]]$location


#Calculate distance for each postcode
user_dt$origin <- paste(user_dt$lat,"+",user_dt$lng,sep="")
destination="51.49293+-0.14093"

unique_combo <- unique(user_dt[,c(2,3,4)])


calcDistance <- function(origin){
print(origin)	
results <- gmapsdistance(origin, destination, mode="bicycling",key=API_key)
list_res <-list(Time=results$Time, 
                Distance= results$Distance, 
                Status=results$Status) 

 
 
return(list_res)
}

start <- 1
finish <- 25
i <- 1
n <- dim(unique_combo)[1]/25

for(j in 1:n)
{
	distance_df <- do.call("rbind", apply(as.matrix(unique_combo$origin[start:complete]),1,calcDistance))
	if(i==1){
	distance_complete <- distance_df}else{distance_complete <- rbind(distance_complete,distance_df)}
	i <- i+1
	start <- start+25
	complete <- start+25
}


