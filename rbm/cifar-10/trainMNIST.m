clear;
addpath(['..' filesep 'DeepNeuralNetwork']);

% if you want to test with small number of samples, 
% please uncomment the following

TrainNum = 5000; % up to 10000
TestNum = 1000; % up to 10000

load(['.' filesep 'cifar-10-batches-mat' filesep 'data_batch_1.mat']);
TrainImages = double(data);
TrainImages = TrainImages(randperm(10000, TrainNum), :);
TrainLabelsInd = labels;
TrainLabelsInd = TrainLabelsInd(1:TrainNum,:);
TrainLabels = zeros(numel(TrainLabelsInd), 10);
for i = 1:size(TrainLabelsInd)
    TrainLabels(i, TrainLabelsInd(i) + 1) = 1;
end


nodes = [3072 2048 1024 800 500 300 200 150 100 80 60 40 30 20 15 10]; % just example!
bbdbn = randDBN( nodes, 'BBDBN' );
nrbm = numel(bbdbn.rbm);

opts.MaxIter = 100;
opts.BatchSize = 1000;
opts.Verbose = true;
opts.StepRatio = 0.1;
opts.object = 'CrossEntropy';

opts.Layer = nrbm-1;
bbdbn = pretrainDBN(bbdbn, TrainImages, opts);
bbdbn = SetLinearMapping(bbdbn, TrainImages, TrainLabels);

opts.Layer = 0;
bbdbn = trainDBN(bbdbn, TrainImages, TrainLabels, opts);

save('mnistbbdbn.mat', 'bbdbn' );




