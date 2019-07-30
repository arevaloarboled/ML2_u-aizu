Sys.setenv(LANG = "en")
library(ggplot2)
library(caret)

library(scales)

ggplotConfusionMatrix<- function(m,p,r,n){
  #mytitle <- paste("Accuracy", percent_format()(m$overall[1]), "Kappa", percent_format()(m$overall[2]))
  mytitle <- paste("Accuracy", percent_format()(m$overall[1]),"Precision",percent_format()(p),"recall",percent_format()(r))
  #mytitle <- paste("Accuracy", percent_format()(m$overall[1]))
  d=as.data.frame(m$table/n);
  d$Freq=d$Freq*100;#percent_format()(d$Freq);
  p <-
    ggplot(data = d ,
           aes(x = Reference, y = Prediction)) +
    geom_tile(aes(fill = log(Freq)), colour = "white") +
    scale_fill_gradient(low = "white", high = "steelblue") +
    geom_text(aes(x = Reference, y = Prediction, label = Freq)) +
    theme(legend.position = "none",
      axis.text.x= element_text(size = 18,angle=90),
      axis.text.y= element_text(size = 18),
      axis.title.x= element_text(size = 18,vjust = 0.1),
      axis.title.y= element_text(size = 18,angle = 90,vjust = 1.1),
      strip.text.x = element_text(size =18)
    ) +
    ggtitle(mytitle)
  return(p)
}


#name=c("0-zero","1-one","2-two","3-three","4-four","5-five","6-six","7-seven","8-eigth","9-nine");
name=c("T-shirt/top","Trouser","Pullover","Dress","Coat","Sandal","Shirt","Sneaker","Bag","Ankle");
#name=c('airplane','automobile','bird','cat','deer','dog','frog','horse','ship','truck');

#ds=matrix(c("dbn_fashion_actual","dbn_fashion_predict","dbn_fashion_actual","dbn_mnist_predict"),2,2);
#ds=matrix(c("dbn_fashion_actual.csv","dbn_fashion_predict.csv","dbn_fashion_actual.csv","dbn_mnist_predict.csv"),2,2);
label=c(as.matrix(read.csv(paste("Predictions/","dbn_fashion_actual.csv",sep=""),header=FALSE)));
predict=c(as.matrix(read.csv(paste("Predictions/","dbn_fashion_predict.csv",sep=""),header=FALSE)));

for (i in 1:length(label)) {
  label[i]=name[as.numeric(label[i])]
  predict[i]=name[as.numeric(predict[i])]
}

cfm=confusionMatrix(factor(predict),factor(label));

diag = diag(cfm$table) # number of correctly classified instances per class 
rowsums = apply(cfm$table, 1, sum) # number of instances per class
colsums = apply(cfm$table, 2, sum) # number of predictions per class
 recall= diag / colsums 
precision = diag / rowsums 
#mean(precision)
#mean(recall)
#proc.time()-ptm


ggplotConfusionMatrix(cfm,mean(precision),mean(recall),length(predict))
ggsave("fashion_bdm.png",plot=last_plot())






data=read.csv('predict_FMNIST.csv');
level=c(matrix(unique(data$predict)));
data$predict=factor(data$predict,levels=level,labels=1:length(unique(data$predict)))
write.csv(as.numeric(data$predict),"fmnist_predict.csv");

data=read.csv('target_FMNIST.csv');
data$target=factor(data$target,levels=level,labels=1:length(unique(data$target)))
write.csv(as.numeric(data$target),"fmnist_target.csv");