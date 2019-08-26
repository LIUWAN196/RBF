clc;
clear all;
close all;
warning off
%% ---- 免疫算法优化RBF实现中心点选择 
% 加载数据
% load input1 %原始图片数据
load feature %CNN提取到的数据
input1=fv;
load test_labels
%由于CNN提取到的图片特征维度太高，维度太高这不能直接用于训练rbf网络，这样速度很慢
%因此首先利用pca降维方法把降至D维，但是为了怕信息削减过多影响模型，所以D取10比较好,
[PCALoadings,PCAScores,PCAVar] = pca(input1);%利用PCA进行降维
inpu=PCAScores(:,1:10)';%为了加快训练速度，利用pca进行降维至10维，当前也可以不，只要你电脑好
% 输入数据归一化
input=mapminmax(inpu,0,1)';
%
outpu=test_labels';
output=[];
for i=1:610
    output(outpu(i),i)=1;
end%标签转化  第1类为1 0 0 0 第二类为 0 1 0 0 
%%

%随机提取500个样本为训练样本，110个样本为预测样本
rng(1);
[m n]=sort(rand(1,610));
data=input(n(1:500),:);
label=output(:,n(1:500))';%训练集及其对应标签

data_test=input(n(501:610),:);
T_test=output(:,n(501:610))';%测试集及其对应标签


%% 使用免疫算法对中心点进行选择，并利用选择得到的中心点计算sigma
% 这样就不需要利用聚类来选择中心点，从而避免了聚类选择中心点时初始中心点的选择问题
n_center_vec = 11;
rng(1);
h=immune_for_rbf(n_center_vec,data,label,data_test,T_test);
% 将寻优的中心点重新用于训练RBF神经网络
C=reshape(h,n_center_vec,size(data,2));
%% Calulate sigma 
n_data = size(data,1);
% then calucate sigma
sigma = zeros(n_center_vec, 1);
for i=1:n_center_vec

    L2 = (bsxfun(@minus, data, C(i,:)).^2);
    L2 = sum(L2(:));
    L2=max(L2);
    sigma(i) = L2/sqrt(2*norm(C(i,:),2));
    
end



%% 利用最小二乘法计算隐含层到输出层输出权重
% kernel matrix
k_mat = zeros(n_data, n_center_vec);

for i=1:n_center_vec
   r = bsxfun(@minus, data, C(i,:)).^2;%%||X-C||^2
   r = sum(r,2);
   k_mat(:,i) = exp((-r.^2)/(2*sigma(i)^2));
end

W = pinv(k_mat'*k_mat)*k_mat'*label;

%% 预测
% 训练集
y1 = RBF_predict(data, W, sigma, C);
[I J]=max(y1,[],2);
[I1 J1]=max(label,[],2);
train_rbf_acc=sum(J1==J)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('测试输出','真实标签')
title('rbf神经网络做4分类')
xlabel('样本数')
ylabel('分类标签')
hold off
%% 预测
% 测试集
y2 = RBF_predict(data_test, W, sigma, C);
[I J]=max(y2,[],2);
[I1 J1]=max(T_test,[],2);
test_rbf_acc=sum(J1==J)/length(J)

figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('测试输出','真实标签')
title('rbf神经网络做4分类')
xlabel('样本数')
ylabel('分类标签')
hold off