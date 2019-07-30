function [train,label,test,tlabel] = loads(type)
if type==0
    [train_data train_label test_data test_label] =mnistread('FASHION/');
elseif type==1
    [train_data train_label test_data test_label] =mnistread('MNIST/');
else
    ch_d=randi([1,5]);
    to_load=strcat(strcat('CIFAR/data_batch_',int2str(ch_d)),'.mat');
    load(to_load);
    train=data;
    label=labels;
    load('CIFAR/test_batch.mat');
    test=data;
    tlabel=labels;
    P=0.2;
    idx=randperm(10000);
    select=1:round(P*10000);
    test=test(idx(select),:);
    tlabel=tlabel(idx(select),:);
    d=size(tlabel);
    t=zeros(d(1),10);
    tlabel=tlabel+1;
    for i=1:d(1)
        t(i,tlabel(i))=1;
    end    
    tlabel=t;
    d=size(label);
    t=zeros(d(1),10);
    label=label+1;
    for i=1:d(1)
        t(i,label(i))=1;
    end    
    label=t;
end

if type==0 || type==1
    P=0.2;
    idx=randperm(50000);
    select=1:round(P*50000);
    train=train_data(idx(select),:);
    label=train_label(idx(select),:);
    P=0.2;
    idx=randperm(10000);
    select=1:round(P*10000);
    test=test_data(idx(select),:);
    tlabel=test_label(idx(select),:);    
end
train=double(train);
test=double(test);
end

