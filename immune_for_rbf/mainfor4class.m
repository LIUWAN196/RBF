%% 没有优化的RBF
clc;
clear all;
close all;
warning off
%% ---- RBF实现
% load input1 %原始图片数据
load feature %CNN提取到的数据
input1=fv;
load test_labels
%由于CNN提取到的图片特征维度太高，维度太高这不能直接用于训练rbf网络，这样速度很慢
%因此首先利用pca降维方法把降至D维，但是为了怕信息削减过多影响模型，所以D取10比较好,
[PCALoadings,PCAScores,PCAVar] = pca(input1);%利用PCA进行降维
input=PCAScores(:,1:10);%利用pca进行降维至10维
outpu=test_labels';
output=[];
for i=1:610
    output(outpu(i),i)=1;
end


%随机提取500个样本为训练样本，110个样本为预测样本
[m n]=sort(rand(1,610));
data=input(n(1:500),:);
label=output(:,n(1:500))';
data_test=input(n(501:610),:);
T_test=output(:,n(501:610))';

%% Using kmeans to find cinter vector
n_center_vec = 11;
  rng(1);
[idx, C] = kmeans(data, n_center_vec);


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



%% Calutate weights
% kernel matrix
k_mat = zeros(n_data, n_center_vec);

for i=1:n_center_vec
   r = bsxfun(@minus, data, C(i,:)).^2;
   r = sum(r,2);
   k_mat(:,i) = exp((-r.^2)/(2*sigma(i)^2));
end

W = pinv(k_mat'*k_mat)*k_mat'*label;

%% 预测
% 训练集
y1 = RBF_predict(data, W, sigma, C);
[I J]=max(y1,[],2);
[I1 J1]=max(label,[],2);
rbf_acc=sum(J1==J)/length(J)
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
rbf_acc=sum(J1==J)/length(J)

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