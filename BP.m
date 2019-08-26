
% չʾBP��ѵ��������
% bp_train_accuracy =
%     0.9800
% չʾBP�Ĳ��Լ�����
% bp_test_accuracy =
%     0.9455
%% �ô�������bp�����繤�������ͼƬ����
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
% ��ǩת��
output=[];
for i=1:610
    output(tr_y(i),i)=1;
end

%%
%����ԭʼͼƬת��Ϊ100*100�����ÿ��ͼƬ��10000��������ά��̫���ⲻ��ֱ������ѵ��bp���磬
%�����������pca��ά������10000����D��������paretoͼ����D=5�Ͳ���ˣ�����Ϊ������Ϣ��������Ӱ��ģ�ͣ�����Dȡ10�ȽϺ�,
[PCALoadings,PCAScores,PCAVar] = pca(input1);%����PCA���н�ά
% percent_explained = 100 * PCAVar / sum(PCAVar);
% pareto(percent_explained)   %paretoͼ��ֻ��ʾǰ95%���ۻ��ֲ�
% xlabel('���ɷ�')
% ylabel('������(%)')
% title('���ɷֹ�����')
input=PCAScores(:,1:10);%����pca���н�ά��10ά
%�������1ά���6ά


%�����ȡ500������Ϊѵ��������110������ΪԤ������
[m n]=sort(rand(1,610));
P_train=input(n(1:500),:)';
T_train=output(:,n(1:500));
P_test=input(n(501:610),:)';
T_test=output(:,n(501:610));


%% ��������
s1=25;%������ڵ�

net_bp=newff(P_train,T_train,[s1 10 ]);
% ����ѵ������
net_bp.trainParam.epochs = 100;
net_bp.trainParam.goal = 0.0001;
net_bp.trainParam.lr = 0.01;
net_bp.trainParam.showwindow = 1;
%% ѵ��������BP����
net_bp = train(net_bp,P_train,T_train);%ѵ��

%%ѵ����׼ȷ��
bp_sim = sim(net_bp,P_train);%����
[I J]=max(bp_sim',[],2);
[I1 J1]=max(T_train',[],2);
disp('չʾBP��ѵ��������')
bp_train_accuracy=sum(J==J1)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('����ѵ�����','��ʵ��ǩ')
title('BP��������4����')
xlabel('������')
ylabel('�����ǩ')
hold off
%% ���Լ�׼ȷ��
tn_bp_sim = sim(net_bp,P_test);%����
[I J]=max(tn_bp_sim',[],2);
[I1 J1]=max(T_test',[],2);
disp('չʾBP�Ĳ��Լ�����')
bp_test_accuracy=sum(J==J1)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('�������','��ʵ��ǩ')
title('BP��������4����')
xlabel('������')
ylabel('�����ǩ')
hold off