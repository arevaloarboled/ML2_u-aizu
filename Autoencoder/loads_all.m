function [train,label] = loads_all(type)  %0:Fashion,1:MINST,2:CIFAR
db='';
if type==0
    [train_data train_label test_data test_label] =mnistread('FASHION/');
    db='fashion';
elseif type==1
    [train_data train_label test_data test_label] =mnistread('MNIST/');
    db='mnist';
else    
    db='cifar';
    train=[];
    label=[];
    for i=1:5
        to_load=strcat(strcat('CIFAR/data_batch_',int2str(i)),'.mat');
        load(to_load);        
        train=[train,data'];
        label=[label,labels'];
    end              
    load('CIFAR/test_batch.mat');
    train=[train,data'];
    label=[label,labels'];
    train=train';
    label=label';
    d=size(label);
    t=zeros(d(1),10);
    label=label+1;
    for i=1:d(1)
        t(i,label(i))=1;
    end    
    label=t;
end
if type==0 || type==1
    train=[train_data' test_data'];
    label=[train_label' test_label'];
    train=train';
    label=label';
end
train=double(train);
csvwrite(strcat('train_',db,'.csv'),train);
csvwrite(strcat('label_',db,'.csv'),label);
end

