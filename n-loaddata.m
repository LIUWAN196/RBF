clear;clc;
samples_dir = 'G:\academic\paper\ДњТы\matlab\car_data0225\train\';

labels = [];
samples = [];
t=1;
file_name = [];

bigclass_list = dir(samples_dir);

for i = 3: length (bigclass_list)

    bigclass_name = bigclass_list(i).name;
    smallclass_list = dir(strcat(samples_dir,bigclass_name,'\'));
    for j = 3:length(smallclass_list )
        
%             load(strcat(samples_dir,'\',bigclass_name,'\',smallclass_name,'\',cycloneclass_name,'\',samples_list(k).name));
            car_pixel = mat2gray(imread(strcat(samples_dir,'\',bigclass_name,'\',smallclass_list(j).name)));
%             car_pixel = mat2gray(imread(strcat(samples_dir,'\',bigclass_name,'\',smallclass_list(k).name)));
%             car_pixel = imread(strcat(samples_dir,'\',bigclass_name,'\',smallclass_list(j).name));
            split1 = strsplit(bigclass_name ,'_');
            label = str2num(split1{2});
            labels = cat(1, labels , label);
            samples = cat (3 , samples , car_pixel);
            
            t=t+1
    end
end

train_labels = labels ;
car_trainsamples = samples;
TRAINS_N_ALL  = t-1 ;

   file_name= 'train_labels';
   save(file_name,'train_labels');
   file_name= 'car_trainsamples';
   save(file_name,'car_trainsamples'); 
   file_name = 'TRAINS_N_ALL';
   save(file_name , 'TRAINS_N_ALL');



   


clear;clc;
samples_dir = 'G:\academic\paper\ДњТы\matlab\car_data0225\test\';

labels = [];
samples = [];
t=1;
file_name = [];

bigclass_list = dir(samples_dir);

for i = 3: length (bigclass_list)

    bigclass_name = bigclass_list(i).name;
    smallclass_list = dir(strcat(samples_dir,bigclass_name,'\'));
    for j = 3:length(smallclass_list )
        
%             load(strcat(samples_dir,'\',bigclass_name,'\',smallclass_name,'\',cycloneclass_name,'\',samples_list(k).name));
            car_pixel = mat2gray(imread(strcat(samples_dir,'\',bigclass_name,'\',smallclass_list(j).name)));
%             car_pixel = imread(strcat(samples_dir,'\',bigclass_name,'\',smallclass_list(j).name));
            split1 = strsplit(bigclass_name ,'_');
            label = str2num(split1{2});
            labels = cat(1, labels , label);
            samples = cat (3 , samples , car_pixel);
            
            t=t+1
        end
        end

test_labels = labels ;
car_testsamples = samples;
TEST_N_ALL  = t-1 ;


   file_name= 'test_labels';
   save(file_name,'test_labels');   
   file_name= 'car_testsamples';
   save(file_name,'car_testsamples');

   file_name= 'TEST_N_ALL';
   save(file_name,'TEST_N_ALL');

% car_trainsamples = samples;
% file_name = 'car_trainsamples'
% save(file_name,'car_trainsamples');
% train_labels = labels ;
% file_name = 'train_labels'
% save(file_name,'train_labels');   
   
   

   