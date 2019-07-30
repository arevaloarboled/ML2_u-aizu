clear all;
[train label test tlabel] =loads(1); %0:Fashion,1:MINST,2:CIFAR
%[train label test tlabel] =mnistread('FASHION/');
hiddenSize = 42;
%autoenc = trainAutoencoder(train',hiddenSize,'MaxEpochs',200,'L2WeightRegularization',0.05,'SparsityRegularization',4,'SparsityProportion',0.15,'UseGPU',true);
%autoenc = trainAutoencoder(train',hiddenSize,'L2WeightRegularization',0.05,'SparsityRegularization',4,'SparsityProportion',0.15);
%autoenc = trainAutoencoder(train',hiddenSize,'MaxEpochs',100);
autoenc = trainAutoencoder(train',hiddenSize,'MaxEpochs',1,'L2WeightRegularization',0.01,'SparsityRegularization',4,'SparsityProportion',0.15,'ScaleData', true,'EncoderTransferFunction','satlin','DecoderTransferFunction','purelin');
enc=encode(autoenc,train');
hiddenSize = hiddenSize/2;
% autoenc2 = trainAutoencoder(enc,hiddenSize,'L2WeightRegularization',0.04,'SparsityRegularization',4,'SparsityProportion',0.1, 'ScaleData', false);
autoenc2 = trainAutoencoder(enc,hiddenSize,'MaxEpochs',1,'L2WeightRegularization',0.005,'SparsityRegularization',4,'SparsityProportion',0.1,'ScaleData', true,'EncoderTransferFunction','satlin','DecoderTransferFunction','purelin');
enc2=encode(autoenc2,enc);
softnet=trainSoftmaxLayer(enc2,label','MaxEpochs',100);
MLP=stack(autoenc,autoenc2,softnet);
% softnet=trainSoftmaxLayer(enc,label');
% MLP=stack(autoenc,softnet);
P=MLP(test');
plotconfusion(tlabel',P);