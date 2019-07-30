clear;
addpath(['..' filesep 'DeepNeuralNetwork']);

mnistfiles = 0;
if( exist('t10k-images-idx3-ubyte', 'file') == 2 )
    mnistfiles = mnistfiles + 1;
end
if( exist('t10k-labels-idx1-ubyte', 'file') == 2 )
    mnistfiles = mnistfiles + 1;
end
if( exist('train-images-idx3-ubyte', 'file') == 2 )
    mnistfiles = mnistfiles + 1;
end
if( exist('train-labels-idx1-ubyte', 'file') == 2 )
    mnistfiles = mnistfiles + 1;
end

if( mnistfiles < 4 )
    warning('Can not find mnist data files. Please download four data files from http://yann.lecun.com/exdb/mnist/ . Unzip and copy them to same folder as testMNIST.m');
    return;
end

[TrainImages TrainLabels TestImages TestLabels] = mnistread();

% if you want to test with small number of samples, 
% please uncomment the following

TrainNum = 5000; % up to 60000
TestNum = 10000; % up to 10000

TrainImages = TrainImages(1:TrainNum,:);
TrainLabels = TrainLabels(1:TrainNum,:);

TestImages = TestImages(1:TestNum,:);
TestLabels = TestLabels(1:TestNum,:);

load mnistbbdbn;

% rmse= CalcRmse(bbdbn, TrainImages, TrainLabels);
% ErrorRate= CalcErrorRate(bbdbn, TrainImages, TrainLabels);
% fprintf( 'For training data:\n' );
% fprintf( 'rmse: %g\n', rmse );
% fprintf( 'ErrorRate: %g\n', ErrorRate );

rmse = CalcRmse(bbdbn, TestImages, TestLabels);
ErrorRate = CalcErrorRate(bbdbn, TestImages, TestLabels);
fprintf( 'For test data:\n' );
fprintf( 'rmse: %g\n', rmse );
fprintf( 'ErrorRate: %g\n', ErrorRate );

ConfusionMatrix = CalcConfusionMatrix(bbdbn, TestImages, TestLabels);
writematrix(ConfusionMatrix, 'dbn_mnist_10k.csv');

out = v2h( bbdbn, TestImages );
[~, pred] = max(out, [], 2);
[~, act]  = max(TestLabels, [], 2);
writematrix(pred, 'dbn_mnist_predict_10k.csv');
writematrix(act, 'dbn_mnist_actual_10k.csv');
