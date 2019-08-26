clc;
clear all;
close all;
warning off
%% ---- �����㷨�Ż�RBFʵ�����ĵ�ѡ�� 
% ��������
% load input1 %ԭʼͼƬ����
load feature %CNN��ȡ��������
input1=fv;
load test_labels
%����CNN��ȡ����ͼƬ����ά��̫�ߣ�ά��̫���ⲻ��ֱ������ѵ��rbf���磬�����ٶȺ���
%�����������pca��ά�����ѽ���Dά������Ϊ������Ϣ��������Ӱ��ģ�ͣ�����Dȡ10�ȽϺ�,
[PCALoadings,PCAScores,PCAVar] = pca(input1);%����PCA���н�ά
inpu=PCAScores(:,1:10)';%Ϊ�˼ӿ�ѵ���ٶȣ�����pca���н�ά��10ά����ǰҲ���Բ���ֻҪ����Ժ�
% �������ݹ�һ��
input=mapminmax(inpu,0,1)';
%
outpu=test_labels';
output=[];
for i=1:610
    output(outpu(i),i)=1;
end%��ǩת��  ��1��Ϊ1 0 0 0 �ڶ���Ϊ 0 1 0 0 
%%

%�����ȡ500������Ϊѵ��������110������ΪԤ������
rng(1);
[m n]=sort(rand(1,610));
data=input(n(1:500),:);
label=output(:,n(1:500))';%ѵ���������Ӧ��ǩ

data_test=input(n(501:610),:);
T_test=output(:,n(501:610))';%���Լ������Ӧ��ǩ


%% ʹ�������㷨�����ĵ����ѡ�񣬲�����ѡ��õ������ĵ����sigma
% �����Ͳ���Ҫ���þ�����ѡ�����ĵ㣬�Ӷ������˾���ѡ�����ĵ�ʱ��ʼ���ĵ��ѡ������
n_center_vec = 11;
rng(1);
h=immune_for_rbf(n_center_vec,data,label,data_test,T_test);
% ��Ѱ�ŵ����ĵ���������ѵ��RBF������
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



%% ������С���˷����������㵽��������Ȩ��
% kernel matrix
k_mat = zeros(n_data, n_center_vec);

for i=1:n_center_vec
   r = bsxfun(@minus, data, C(i,:)).^2;%%||X-C||^2
   r = sum(r,2);
   k_mat(:,i) = exp((-r.^2)/(2*sigma(i)^2));
end

W = pinv(k_mat'*k_mat)*k_mat'*label;

%% Ԥ��
% ѵ����
y1 = RBF_predict(data, W, sigma, C);
[I J]=max(y1,[],2);
[I1 J1]=max(label,[],2);
train_rbf_acc=sum(J1==J)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('�������','��ʵ��ǩ')
title('rbf��������4����')
xlabel('������')
ylabel('�����ǩ')
hold off
%% Ԥ��
% ���Լ�
y2 = RBF_predict(data_test, W, sigma, C);
[I J]=max(y2,[],2);
[I1 J1]=max(T_test,[],2);
test_rbf_acc=sum(J1==J)/length(J)

figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('�������','��ʵ��ǩ')
title('rbf��������4����')
xlabel('������')
ylabel('�����ǩ')
hold off