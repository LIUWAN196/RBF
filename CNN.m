clear
clc

% load TEST_LABELS
% load TEST_SAMPLES
% load TRAIN_LABELS
% load TRAIN_SAMPLES
load TEST_N_ALL
load TRAINS_N_ALL

load test_labels
load train_labels 

load car_trainsamples
load car_testsamples
%%
train_labels=test_labels;
[TRAINS_N_ALL_TEST,~]=size(train_labels );


opts.alpha = 0.01;         %学习率
opts.batchsize =5;       %batch
opts.numepochs = 300;     %迭代周期
batch_size = opts.batchsize ;
train_remain = mode (TRAINS_N_ALL_TEST,batch_size) ; 



car_trainsamples = squeeze (car_trainsamples);
for i = 1:TRAINS_N_ALL_TEST
   TRAIN_LABELS_ONEHOT (train_labels (i),i) = 1 ;
end

if train_remain ~= 0
    train_increase = (fix ( TRAINS_N_ALL_TEST /batch_size)+1) *batch_size - TRAINS_N_ALL_TEST ;
    car_trainsamples = cat ( 3 , car_trainsamples , car_trainsamples(:,:,end-train_increase+1:end));
    TRAIN_LABELS_ONEHOT = cat (2,TRAIN_LABELS_ONEHOT,TRAIN_LABELS_ONEHOT(:,end-train_increase+1:end));
end

[~,t]=size ( TRAIN_LABELS_ONEHOT );



rand('state',0)
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 4, 'kernelsize', 9) %convolution layer 第一个参数是卷积核个数，卷积尺寸
    struct('type', 's', 'scale', 4) %sub sampling layer 池化层参数
    struct('type', 'c', 'outputmaps', 16, 'kernelsize', 9) %convolution layer
    struct('type', 's', 'scale', 2) 
%subsampling layer
};
cnn = cnnsetup(cnn, car_trainsamples, TRAIN_LABELS_ONEHOT);

 
cnn = cnntrain(cnn,car_trainsamples, TRAIN_LABELS_ONEHOT, opts);

figure; plot(cnn.rL);
% cnn = cnnff (cnn , test_x);
[er, bad , net , h] = cnntest(cnn,car_testsamples,test_labels);
oa = sum(h' == test_labels)/610*100;
fprintf ('OA:%f%%\n',oa);
