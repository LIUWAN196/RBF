%% û���Ż���RBF
clc;
clear all;
close all;
warning off
%% ---- RBFʵ��
% load input1 %ԭʼͼƬ����
load feature %CNN��ȡ��������
input1=fv;
load test_labels
%����CNN��ȡ����ͼƬ����ά��̫�ߣ�ά��̫���ⲻ��ֱ������ѵ��rbf���磬�����ٶȺ���
%�����������pca��ά�����ѽ���Dά������Ϊ������Ϣ��������Ӱ��ģ�ͣ�����Dȡ10�ȽϺ�,
[PCALoadings,PCAScores,PCAVar] = pca(input1);%����PCA���н�ά
input=PCAScores(:,1:10);%����pca���н�ά��10ά
outpu=test_labels';
output=[];
for i=1:610
    output(outpu(i),i)=1;
end


%�����ȡ500������Ϊѵ��������110������ΪԤ������
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

%% Ԥ��
% ѵ����
y1 = RBF_predict(data, W, sigma, C);
[I J]=max(y1,[],2);
[I1 J1]=max(label,[],2);
rbf_acc=sum(J1==J)/length(J)
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
rbf_acc=sum(J1==J)/length(J)

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