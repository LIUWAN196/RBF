% function test_example_CNN
clear
clc
close all
%%
load test_labels
load car_testsamples
%%
train_x = car_testsamples;
tr_y = test_labels;
% ��ǩת��
train_y=[];
for i=1:610
    train_y(tr_y(i),i)=1;
end

%%
rand('state',0)

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 4, 'kernelsize', 9) %convolution layer
    struct('type', 's', 'scale', 4) %sub sampling layer
    struct('type', 'c', 'outputmaps', 16, 'kernelsize', 9) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};

%% ��������
opts.alpha = 1;
opts.batchsize = 10;
opts.numepochs = 1;
%% ѵ�� CNN

cnn = cnnsetup(cnn, train_x, train_y);
cnn = cnntrain(cnn, train_x, train_y, opts);
%% ������ȡ ��ȫ���Ӳ��������Ϊ���������ǵڶ���subsampling layerչ��������ݣ�Ҳ����CNN�ķ�����ǰ�����ݾ�����ȡ����������
cnnout = cnnff(cnn, train_x);%cnnout.fvΪCNN��ȡ��������
fv=cnnout.fv;
fv=fv';
% save feature fv

% [er, bad] = cnntest(cnn, test_x, test_y);

%plot mean squared error
% figure; plot(cnn.rL);
% assert(er<0.12, 'Too big error');
