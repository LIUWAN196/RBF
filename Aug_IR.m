%% WARNING:THE ORIGINAL DATA WILL BE COVERED, PLEASE BACKUP THEM.

%%
data_dir = 'G:\academic\paper\ДњТы\matlab\car_data0225\test\';
big_class = dir(data_dir);
%save_nor = 'H:\Data&Program\nor\';
% save_dir = 'G:\academic\paper\ДњТы\matlab\AUG_DATA\test\';
% save_type = '.mat';

for bc = 3:length(big_class)
    big_class_name = big_class(bc).name;
    big_class_dir = strcat(data_dir,big_class_name,'\');
    small_class = dir(big_class_dir);
    for sc = 3:length(small_class)
        small_class_name = small_class(sc).name;
        sample_dir = strcat(big_class_dir,small_class_name,'\');

         
%%
% read data
    ori_data = imread(strcat(big_class_dir,small_class_name));
%     car_pixel = rgb2gray(ori_data);
% normalize data
    ori_data = [];
    for band = 1:3
        ori_data(:,:,band)=mat2gray(ori_data(:,:,band));
%     end
%     ori_data = [];
%     ori_data = mat2gray( car_pixel );
% augment data
%     rot_90 = imrotate(ori_data,90);
%     rot_180 = imrotate(ori_data,180);
%     rot_270 = imrotate(ori_data,270);
%     flp_hor = flip(ori_data,2);
%     flp_ver = flip(ori_data,1);
%     rot_45 = imrotate(ori_data,45);
%     rot_45 = rot_45(length(rot_45)/2-120:length(rot_45)/2+119,length(rot_45)/2-120:length(rot_45)/2+119,:);
%     rot_135 = imrotate(ori_data,135);
%     rot_135 = rot_135(length(rot_135)/2-120:length(rot_135)/2+119,length(rot_135)/2-120:length(rot_135)/2+119,:);
%     rot_225 = imrotate(ori_data,225);
%     rot_225 = rot_225(length(rot_225)/2-120:length(rot_225)/2+119,length(rot_225)/2-120:length(rot_225)/2+119,:);
%     rot_315 = imrotate(ori_data,315);
%     rot_315 = rot_315(length(rot_315)/2-120:length(rot_315)/2+119,length(rot_315)/2-120:length(rot_315)/2+119,:);
%     cover_top_3 = ori_data;
%     cover_top_3(1:length(cover_top_3)/3,:,:) = 0; 
%     cover_bottom_3 = ori_data;
%     cover_bottom_3(2*length(cover_bottom_3)/3:length(cover_bottom_3),:,:) = 0;
% %     cover_left_3 = ori_data;
% %     cover_left_3(:,1:length(cover_left_3)/8,:) = 0;
% %     cover_right_3 = ori_data;
% %     cover_right_3(:,7*length(cover_right_3)/8:length(cover_right_3),:) = 0;
%     sub_120_up = imresize(ori_data,[120,120]);
%     sub_120_up = imresize(sub_120_up,[240,240]);
%     stretch_hor = zeros(240,240,14);
%     stretch_hor(61:180,:,:) = imresize(ori_data,[120,240]);
%     stretch_ver = zeros(240,240,14);
%     stretch_ver(:,61:180,:) = imresize(ori_data,[240,120]);

% show figure

% save data
    ori_data = ori_data;
     imwrite(ori_data,strcat(big_class_dir,small_class_name));    
    %save(strcat(save_nor,sample_name),'cyclone_pixel');
% %     ori_data = rot_90;
% %     imwrite(ori_data,strcat(big_class_dir,'R90~',small_class_name));    
% %     ori_data = rot_180;
% %     imwrite(ori_data,strcat(big_class_dir,'R180',small_class_name));  
% %     ori_data = rot_270;
% %     imwrite(ori_data,strcat(big_class_dir,'R270',small_class_name));  
%     cyclone_pixel = flp_hor;
%     save(strcat(save_dir,'FH~',sample_name),'cyclone_pixel');
%     cyclone_pixel = flp_ver;
%     save(strcat(save_dir,'FV~',sample_name),'cyclone_pixel');
%     cyclone_pixel = rot_45;
%     save(strcat(save_dir,'R45~',sample_name),'cyclone_pixel');
%     cyclone_pixel = rot_135;
%     save(strcat(save_dir,'R135~',sample_name),'cyclone_pixel');
%     cyclone_pixel = rot_225;
%     save(strcat(save_dir,'R225~',sample_name),'cyclone_pixel');
%     cyclone_pixel = rot_315;
%     save(strcat(save_dir,'R315~',sample_name),'cyclone_pixel');
%     cyclone_pixel = cover_top_3;
%     save(strcat(save_dir,'CT3~',sample_name),'cyclone_pixel');
%     cyclone_pixel = cover_bottom_3;
%     save(strcat(save_dir,'CB3~',sample_name),'cyclone_pixel');
% %     car_pixel = cover_left_3;
% %     imwrite(car_pixel,strcat(big_class_dir,'CL8~',small_class_name));  
% % 
% %     car_pixel = cover_right_3;
% %      imwrite(car_pixel,strcat(big_class_dir,'CR3~',small_class_name));
%     cyclone_pixel = sub_120_up;
%     save(strcat(save_dir,'S120U~',sample_name),'cyclone_pixel');
%     cyclone_pixel = stretch_hor;
%     save(strcat(save_dir,'SH~',sample_name),'cyclone_pixel');
%     cyclone_pixel = stretch_ver;
%     save(strcat(save_dir,'SV~',sample_name),'cyclone_pixel');
%%    
        end
    end

    
    
    
