function fit=fitness(n_center_vec,data,label,data_test,T_test,C0)

C=reshape(C0,n_center_vec,size(data,2));
n_data = size(data,1);

% then calucate sigma
sigma = zeros(n_center_vec, 1);
for i=1:n_center_vec
%     [n, d] = knnsearch(data, C(i,:), 'k', K(i));
    L2 = (bsxfun(@minus, data, C(i,:)).^2);
    L2 = sum(L2(:));
    L2=max(L2);
    sigma(i) = L2/sqrt(2*norm(C(i,:),2));
    %sigma=Lmax/sqrt(2*h)
end



%% Calutate weights
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
% y1 = RBF_predict(data, W, sigma, C);
% [I J]=max(y1,[],2);
% [I1 J1]=max(label,[],2);
% rbf_acc=sum(J1==J)/length(J);
%% 预测
% 测试集
y2 = RBF_predict(data_test, W, sigma, C);
[I J]=max(y2,[],2);
[I1 J1]=max(T_test,[],2);
fit=1-sum(J1==J)/length(J);

%以测试集分类错误率为适应度函数

end