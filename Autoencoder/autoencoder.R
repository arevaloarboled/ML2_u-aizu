library(caret);
library(ANN2);
#ds="mnist";
ds="fashion";
#ds="cifar";
data=read.csv(paste(paste("train_",ds,sep=""),".csv",sep=""),header=FALSE);
data_label=read.csv(paste(paste("label_",ds,sep=""),".csv",sep=""),header=FALSE);
##Ordinal data
##Split data between training and testing
#solution<-as.data.frame(table(unlist(data)));
#index = createDataPartition(solution, p = .8, list = F);
#train_data=data[index,];
#test_data=data[-index,];
data=as.matrix(data);
data_label=as.matrix(data_label);
label=c();
for (i in 1:dim(data_label)[1]) {
	label=c(label,match(1,data_label[i,]))
}
label=as.matrix(label);
#train_label=datal[index,];
#test_label=datal[-index,];
#data=data[,1:1024]/255;
#ptm<-proc.time()
NN = neuralnetwork(data[1:50000,], label[1:50000,], hidden.layers = c(42,21), learn.rates = 0.001, verbose = TRUE,L2=0.01,batch.size = 1000,n.epochs=1000);
#proc.time()-ptm
#ptm<-proc.time()
pred = predict(NN, newdata = data[50000:60000,]);
#proc.time()-ptm
#p=as.numeric(pred$predictions);

cfm=confusionMatrix(factor(as.numeric(pred$predictions)),factor(label[50000:60000,]));
#write.csv(as.numeric(pred$predictions),"p.csv",row.names=FALSE, na="",col.names=FALSE, sep=",");
#write.csv(label[50000:60000,],"l.csv",row.names=FALSE, na="",col.names=FALSE, sep=",");

diag = diag(cfm$table); # number of correctly classified instances per class 
rowsums = apply(cfm$table, 1, sum); # number of instances per class
colsums = apply(cfm$table, 2, sum); # number of predictions per class
recall= diag / colsums ;
precision = diag / rowsums;

#save.image('fashion.Rdata');

library(scales)

ggplotConfusionMatrix <- function(m,p,r){
  #mytitle <- paste("Accuracy", percent_format()(m$overall[1]), "Kappa", percent_format()(m$overall[2]))
  mytitle <- paste("Accuracy", percent_format()(m$overall[1]),"Precision",percent_format()(p),"recall",percent_format()(r))
  #mytitle <- paste("Accuracy", percent_format()(m$overall[1]))
  p <-
    ggplot(data = as.data.frame(m$table) ,
           aes(x = Reference, y = Prediction)) +
    geom_tile(aes(fill = log(Freq)), colour = "white") +
    scale_fill_gradient(low = "white", high = "steelblue") +
    geom_text(aes(x = Reference, y = Prediction, label = Freq)) +
    theme(legend.position = "none",
      axis.text.x= element_text(size = 18),
      axis.text.y= element_text(size = 18),
      axis.title.x= element_text(size = 18,vjust = 0.1),
      axis.title.y= element_text(size = 18,angle = 90,vjust = 1.1),
      strip.text.x = element_text(size =18)
    ) +
    ggtitle(mytitle)
  return(p)
}

# ggplotConfusionMatrix(cfm,mean(precision),mean(recall));
# ggsave(paste(ds,"_knn_cfm.png",sep=""),plot=last_plot());

# tmp_NN = neuralnetwork(data[1:50000,], label[1:50000,], hidden.layers = c(42), learn.rates = 0.001, verbose = TRUE,L2=0.01,batch.size = 100,n.epochs=10);
# cfm$overall["Accuracy"];


# pca = autoencoder(encode(NN,data[1:50000,]), hidden.layers = c(2), learn.rates = 0.001, verbose = TRUE,L2=0.01,batch.size = 1000);
# pca_data=encode(pca,encode(NN,data[50000:60000,]));
# to_p=data.frame(pca1=pca_data[,1],pca2=pca_data[,2],cl=label[50000:60000,]);
# ggplot(to_p,aes(pca1,pca2))+geom_point(aes(colour=factor(to_p$cl)))
# ggsave(paste(ds,"_lvq_plot.png",sep=""),plot=last_plot())


# pca=prcomp(t(data[50000:60000,]),center=TRUE)
# to_p=data.frame(pca1=pca$rotation[,"PC1"],pca2=pca$rotation[,"PC2"],cl=label[50000:60000,])
# ggplot(to_p,aes(pca1,pca2))+geom_point(aes(colour=factor(to_p$cl)))