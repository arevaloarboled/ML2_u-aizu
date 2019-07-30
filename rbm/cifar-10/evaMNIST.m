clear;
addpath(['..' filesep 'DeepNeuralNetwork']);

load mnistbbdbn;

% if you want to test with small number of samples, 
% please uncomment the following

TrainNum = 5000; % up to 60000
TestNum = 1000; % up to 10000

load(['.' filesep 'cifar-10-batches-mat' filesep 'test_batch.mat']);
TestImages = double(data);
TestImages = TestImages(1:TestNum, :);
TestLabelsInd = labels;
TestLabelsInd = TestLabelsInd(1:TestNum,:);
TestLabels = zeros(numel(TestLabelsInd), 10);
for i = 1:size(TestLabelsInd)
    TestLabels(i, TestLabelsInd(i) + 1) = 1;
end


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
writematrix(ConfusionMatrix, 'dbn_cifar10.csv');

out = v2h( bbdbn, TestImages );
[~, pred] = max(out, [], 2);
[~, act]  = max(TestLabels, [], 2);
writematrix(pred, 'dbn_cifar10_predict.csv');
writematrix(act, 'dbn_cifar10_actual.csv');
