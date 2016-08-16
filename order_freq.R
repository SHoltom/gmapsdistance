dt <- read.csv("../data/order_history_012082016_withpostcode.csv")
one_item_order <- dt[match(unique(dt$order_number),dt$order_number),]
one_user_order <- one_item_order[match(unique(one_item_order$user_id), one_item_order$user_id),]


order_freq <- as.data.frame(sort(table(one_user_order$postcode),decreasing=T))

colnames(order_freq)[1] <- "No. of customers"

write.csv(order_freq,file="Order_freq_by_postcode.csv",quote=F,row.names=T,col.names=T)


#repeat customer
repeat_order <- as.data.frame(sort(table(one_item_order$user_id),decreasing=T))
colnames(repeat_order) <- "No. of repeat order"

repeat_freq <- as.data.frame(cbind(repeat_order,one_user_order$postcode[match(rownames(repeat_order),one_user_order$user_id)]))

colnames(repeat_freq)[2] <- "Postcode"
write.csv(repeat_freq,file="postcodes_with_repeat_customers.csv",quote=F,row.names=T,col.names=T)

#Q. What are the post codes that have the longest delivery times?
#jobs.start_time - order.created_at is the "queue time"
#jobs.checkout_time - job.start_time is the "pick time"
#deliveries.start_time - jobs.checkout_time is the "pack time"
#deliveries.completed_time - deliveries.start time is the delivery time

dt <- read.csv("../data/order_history_015082016_withpostcode.csv", as.is=T)
dt <- dt[match(unique(dt$order_number),dt$order_number),]

delivery_time <- signif(difftime(strptime(dt$delivery_completed_time,"%Y-%m-%d %H:%M:%S"), strptime (dt$delivery_start_time, "%Y-%m-%d %H:%M:%S"),units="hours"),2)

dt_delivery <- cbind(dt,delivery_time)
dt_ordered <- dt_delivery[order(dt_delivery$delivery_time,decreasing=T),]

write.csv(dt_ordered,file="delivery_times.csv",quote=F,row.names=T,col.names=T)



dt <- read.csv("../data/order_history_012082016_withpostcode.csv",as.is=T)
one_item_order <- dt[match(unique(dt$order_number),dt$order_number),]

asap_orders <- one_item_order[which(one_item_order$order_requested_asap=="t"),]

total_time <- signif(difftime(asap_orders$order_delivery_time, asap_orders$checkout_time,units="mins"),2)
 

 #Q. repeat customer in pimlico

pimlico <- read.csv("../data/Pimlico_Postcode.csv",as.is=T) 

