clear;clc;
samples_dir = 'G:\academic\paper\����\matlab\car_data0225\train\'; %��ȡ����ͼ��λ��

labels = [];
samples = [];
t=1;
file_name = [];

bigclass_list = dir(samples_dir);
for i = 3: length (bigclass_list)

    bigclass_name = bigclass_list(i).name;
    smallclass_list = dir(strcat(samples_dir,'\',bigclass_name,'\'));
   
        for k = 3:length(smallclass_list)

%             load(strcat(samples_dir,'\',bigclass_name,'\',smallclass_name,'\',cycloneclass_name,'\',samples_list(k).name));
%             car_pixel = mat2gray(rgb2gray(imread(strcat(samples_dir,'\',bigclass_name,'\',smallclass_list(k).name))));
%             car_pixel = mat2gray(imread(strcat(samples_dir,'\',bigclass_name,'\',smallclass_list(k).name)));
            %����ȡ��ͼƬ����ת��Ϊ�Ҷ�ͼ��
            car_pixel =imread(strcat(samples_dir,'\',bigclass_name,'\',smallclass_list(k).name));
            samples_names = bigclass_name;
            split = strsplit(samples_names,'_');
            sample_label= str2num(split{2});    %��ͼ�����Ʒָ�󽫱�ǩȡ��
            labels = cat(1, labels , sample_label);
            samples = cat (3 , samples , car_pixel);
            file_name{t,1} = samples_names;
            t=t+1
       
    end
end

%�����ݼ����ǩ�ֱ𱣴����������浽�������ڵ��ļ���
car_trainsamples = samples;
file_name = 'car_trainsamples'
save(file_name,'car_trainsamples');
train_labels = labels ;
file_name = 'train_labels'
save(file_name,'train_labels');