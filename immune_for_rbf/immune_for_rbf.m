function h=immune_for_rbf(n_center_vec,P_train,T_train,P_test,T_test)
% ��������---�����Ż��㷨�Ż�RBF��������

D=n_center_vec*size(P_train,2);                                     %���߸���ά��
NP=20;                                   %���߸�����Ŀ
Xs=1;                                    %ȡֵ����
Xx=0;                                   %ȡֵ����
G=100;                                    %������ߴ���
pm=0.7;                                   %�������
alfa=1;                                   %������ϵ��
belta=1;                                  %������ϵ��   
detas=0.2;                                %���ƶ���ֵ
gen=0;                                    %���ߴ���
Ncl=10;                                   %��¡����
deta0=1*Xs;                               %����Χ��ֵ
%%%%%%%%%%%%%%%%%%%%%%%��ʼ��Ⱥ%%%%%%%%%%%%%%%%%%%%%%%%
f=rand(D,NP)*(Xs-Xx)+Xx;
for np=1:NP
   MSLL(np)= fitness(n_center_vec,P_train,T_train,P_test,T_test,f(:,np));
end
%%%%%%%%%%%%%%%%%�������Ũ�Ⱥͼ�����%%%%%%%%%%%%%%%%%%%
for np=1:NP
    for j=1:NP     
        nd(j)=sum(sqrt((f(:,np)-f(:,j)).^2));
        if nd(j)<detas
            nd(j)=1;
        else
            nd(j)=0;
        end
    end
    ND(np)=sum(nd)/NP;
end
MSLL =  alfa*MSLL- belta*ND;
%%%%%%%%%%%%%%%%%%%�����Ȱ���������%%%%%%%%%%%%%%%%%%%%%%
[SortMSLL,Index]=sort(MSLL);
Sortf=f(:,Index);
%%%%%%%%%%%%%%%%%%%%%%%%����ѭ��%%%%%%%%%%%%%%%%%%%%%%%%
while gen<G
    iter=gen
    for i=1:NP/2
        %%%%%%%%ѡ������ǰNP/2����������߲���%%%%%%%%%%%
        a=Sortf(:,i);
        Na=repmat(a,1,Ncl);
        deta=deta0/gen;
        for j=1:Ncl
            for ii=1:D
                %%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%
                if rand<pm
                    Na(ii,j)=Na(ii,j)+(rand-0.5)*deta;
                end
                %%%%%%%%%%%%%%�߽���������%%%%%%%%%%%%%%%
                if (Na(ii,j)>Xs)  |  (Na(ii,j)<Xx)
                    Na(ii,j)=rand * (Xs-Xx)+Xx;
                end
            end
        end
        Na(:,1)=Sortf(:,i);               %������¡Դ����
        %%%%%%%%%%��¡���ƣ������׺Ͷ���ߵĸ���%%%%%%%%%%
        for j=1:Ncl
           NaMSLL(j) = fitness(n_center_vec,P_train,T_train,P_test,T_test,Na(:,j));
            
        end
        [NaSortMSLL,Index]=sort(NaMSLL);
        aMSLL(i)=NaSortMSLL(1);
        NaSortf=Na(:,Index);
        af(:,i)=NaSortf(:,1);
    end 
    %%%%%%%%%%%%%%%%%%%%������Ⱥ������%%%%%%%%%%%%%%%%%%%
    for np=1:NP/2
        for j=1:NP/2
            nda(j)=sum(sqrt((af(:,np)-af(:,j)).^2));         
            if nda(j)<detas
                nda(j)=1;
            else
                nda(j)=0;
            end
        end
        aND(np)=sum(nda)/NP/2;
    end
    aMSLL =  alfa*aMSLL-  belta*aND;
    %%%%%%%%%%%%%%%%%%%%%%%��Ⱥˢ��%%%%%%%%%%%%%%%%%%%%%%%
    bf=rand(D,NP/2)*(Xs-Xx)+Xx;
    for np=1:NP/2
                  bMSLL(np) = fitness(n_center_vec,P_train,T_train,P_test,T_test,bf(:,np));

      
    end
    %%%%%%%%%%%%%%%%%%%��������Ⱥ������%%%%%%%%%%%%%%%%%%%%
    for np=1:NP/2
        for j=1:NP/2
            ndc(j)=sum(sqrt((bf(:,np)-bf(:,j)).^2));
            if ndc(j)<detas
                ndc(j)=1;
            else
                ndc(j)=0;
            end
        end
        bND(np)=sum(ndc)/NP/2;
    end
    bMSLL =  alfa*bMSLL-  belta*bND;
    %%%%%%%%%%%%%%������Ⱥ��������Ⱥ�ϲ�%%%%%%%%%%%%%%%%%%%
    f1=[af,bf];
    MSLL1=[aMSLL,bMSLL];
    [SortMSLL,Index]=sort(MSLL1);
    Sortf=f1(:,Index);
    gen=gen+1;
    trace(gen)= fitness(n_center_vec,P_train,T_train,P_test,T_test,Sortf(:,1));
end
%%%%%%%%%%%%%%%%%%%%%%%����Ż����%%%%%%%%%%%%%%%%%%%%%%%%
h=Sortf(:,1);                 %���ű���
trace(end);                       %����ֵ
figure,plot(trace)
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title('�׺ͶȽ�������')
end