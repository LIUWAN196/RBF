
% 展示BP的训练集分类
% bp_train_accuracy =
%     0.9800
% 展示BP的测试集分类
% bp_test_accuracy =
%     0.9455
%% 该代码利用bp神经网络工具箱进行图片分类
clc;clear;close all; format compact
%%
load test_labels
load car_testsamples
%%
data = car_testsamples;
for i=1:610
    a=data(:,:,i);
    b=reshape(a,1,128*128);
    input1(i,:)=b;
end
tr_y = test_labels;
% 标签转换
output=[];
for i=1:610
    output(tr_y(i),i)=1;
end

%%
%由于原始图片转换为100*100，因此每个图片是10000个特征，维度太高这不能直接用于训练bp网络，
%因此首先利用pca降维方法把10000降至D，，根据pareto图看出D=5就差不多了，但是为了怕信息削减过多影响模型，所以D取10比较好,
[PCALoadings,PCAScores,PCAVar] = pca(input1);%利用PCA进行降维
% percent_explained = 100 * PCAVar / sum(PCAVar);
% pareto(percent_explained)   %pareto图，只显示前95%的累积分布
% xlabel('主成分')
% ylabel('贡献率(%)')
% title('主成分贡献率')
input=PCAScores(:,1:10);%利用pca进行降维至10维
%把输出从1维变成6维


%随机提取500个样本为训练样本，110个样本为预测样本
[m n]=sort(rand(1,610));
P_train=input(n(1:500),:)';
T_train=output(:,n(1:500));
P_test=input(n(501:610),:)';
T_test=output(:,n(501:610));


%% 建立网络
s1=25;%隐含层节点

net_bp=newff(P_train,T_train,[s1 10 ]);
% 设置训练参数
net_bp.trainParam.epochs = 100;
net_bp.trainParam.goal = 0.0001;
net_bp.trainParam.lr = 0.01;
net_bp.trainParam.showwindow = 1;
%% 训练并测试BP网络
net_bp = train(net_bp,P_train,T_train);%训练

%%训练集准确率
bp_sim = sim(net_bp,P_train);%测试
[I J]=max(bp_sim',[],2);
[I1 J1]=max(T_train',[],2);
disp('展示BP的训练集分类')
bp_train_accuracy=sum(J==J1)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('网络训练输出','真实标签')
title('BP神经网络做4分类')
xlabel('样本数')
ylabel('分类标签')
hold off
%% 测试集准确率
tn_bp_sim = sim(net_bp,P_test);%测试
[I J]=max(tn_bp_sim',[],2);
[I1 J1]=max(T_test',[],2);
disp('展示BP的测试集分类')
bp_test_accuracy=sum(J==J1)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('测试输出','真实标签')
title('BP神经网络做4分类')
xlabel('样本数')
ylabel('分类标签')
hold off