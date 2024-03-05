
clear 
clc

Pat_s='/Volumes/Nika/Folkert/OAM_230103_FK11243_0/Channels/Pos10/';
exp_name='OAM_230103_FK11243_0';
pos=10;
tftp=221;
date=230103;
tc=12; % every how often the image was taken
time_ratio=tc./60;
ch1='Ph3_000.tif'; % phase
ch2='555_mRuby3_000.tif'; % Ime1pr
ch3='555_mKok_000.tif'; % Rim11
ch4='470_mTFP_000.tif'; % Ume6
ch5='505_mNG_000.tif'; % Ime1

path_dir1=dir(fullfile([Pat_s,'*' ch1]));
path_dir2=dir(fullfile([Pat_s,'*' ch2]));
path_dir3=dir(fullfile([Pat_s,'*' ch3]));
path_dir4=dir(fullfile([Pat_s,'*' ch4]));
path_dir5=dir(fullfile([Pat_s,'*' ch5]));

fileNames1 = { path_dir1.name };
fileNames2 = { path_dir2.name };
fileNames3 = { path_dir3.name };
fileNames4 = { path_dir4.name };
fileNames5 = { path_dir5.name };

%load segmentation
path_seg='/Volumes/Nika/Folkert/OAM_230103_FK11243_0/Tracks/';
load([path_seg 'Pos' num2str(pos) '_Tracks_art_new_' num2str(tftp) '_seg_' num2str(tftp+1)])

% load flourophore extraction
load([path_seg exp_name '_pos' num2str(pos) '_FLEX_' num2str(tftp) '_V2'])

load([path_seg exp_name '_EXP_' num2str(date)]);

%figure;imagesc(Mask2{1,180})
% identify the cell of interest 
coIN=43; % cell in the mask
coIN2=find(ALL_COMBO{87,2}(:,2)==10 & ALL_COMBO{87,2}(:,1)==coIN);% cell int the extracrtion

numbF=189;
Klums=5; % rows of images
Rws=2; % columns of images
cell_margin=100;

current_font_size=8; % for channel and time legends

vid=1;

if vid==1
mov_name=[ 'New2' exp_name '_pos_' num2str(pos) 'cell_no_' num2str(coIN)];

  vidObj = VideoWriter(mov_name, 'MPEG-4');
  vidObj.FrameRate = 5; % 15
  vidObj.Quality = 75; % 100
  open(vidObj);
end 

MI=87;
MII=90;
Ume6_peak = 97; 
Rim11_peak = 30; 

tim=[50:200];
for itt=tim%189%length(fileNames1)%
% 
%itt
M0=Mask2{1,itt}==coIN; % selected cell on the tracks, NOT ON THE EXTRACTION
if itt==min(tim)
[x_cn,y_cn]=get_wind_coord1(M0,cell_margin);
end
M1=M0(y_cn,x_cn);

    if itt==min(tim) 

[miu1, sigm1] = OAM_230816_Zinorm_vid_phase4(Pat_s,fileNames1{itt},numbF,y_cn,x_cn);
[miu2, sigm2] = OAM_230816_Zinorm_vid4(Pat_s,fileNames2{itt},numbF,y_cn,x_cn);
[miu3, sigm3] = OAM_230816_Zinorm_vid4(Pat_s,fileNames3{itt},numbF,y_cn,x_cn);
[miu4, sigm4] = OAM_230816_Zinorm_vid4(Pat_s,fileNames4{itt},numbF,y_cn,x_cn);
[miu5, sigm5] = OAM_230816_Zinorm_vid4(Pat_s,fileNames5{itt},numbF,y_cn,x_cn);

    end

I1=OAM_230816_Cleaned_frame_noBack4(Pat_s,fileNames1{itt},y_cn,x_cn);
I1=(I1-miu1)./sigm1; % normalization 
BackG=median(I1(I1~=0));
I1=I1-BackG; % bck correction 
I1 =0.1.*I1+0.2;% imshow(I1)

I2=OAM_230816_Cleaned_frame4(Pat_s,fileNames2{itt},y_cn,x_cn);
I2=(I2-miu2)./sigm2;
BackG2=median(I2(I2~=0));
I2=I2-1.2.*BackG2;
I2 =0.05.*I2+0.06;  %imshow(I2)

I3=OAM_230816_Cleaned_frame4(Pat_s,fileNames3{itt},y_cn,x_cn);
I3=(I3-miu3)./sigm3;
BackG3=median(I3(I3~=0));
I3=I3-1.2.*BackG3;
I3 =0.05.*(I3)+0.1;% imshow(I3)

I4=OAM_230816_Cleaned_frame4(Pat_s,fileNames4{itt},y_cn,x_cn);
I4=(I4-miu4)./sigm4;
BackG4=median(I4(I4~=0));
I4=I4-1.2.*BackG4;
I4 =0.08.*(I4)+0.02; % imshow(I4)

I5=OAM_230816_Cleaned_frame4(Pat_s,fileNames5{itt},y_cn,x_cn);
I5=(I5-miu5)./sigm5;
BackG5=median(I5(I5~=0));
I5=I5-1.2.*BackG5;
I5 =0.07.*(I5)+0.01; % imshow(I5)

[x1,y1]=size(I3);
xc=1:x1;
yc=1:y1;

    xc1=11:(length(xc)+10);
    yc1=1:(length(yc)); 
     
    yc2=[max(yc1)+1:2*(length(yc1))];        
    xc2=11:(length(xc1)+10); 
    
    yc3=[max(yc2)+1:3*(length(yc1))];        
    xc3=11:(length(xc1)+10);

    yc4=[max(yc3)+1:4*(length(yc1))];        
    xc4=11:(length(xc1)+10);

    yc5=[max(yc4)+1:5*(length(yc1))];        
    xc5=11:(length(xc1)+10);

    Iall=zeros(Rws.*length(xc)+20,Klums.*length(yc),3);   
     
    Iall(xc1,yc1,1)=Iall(xc1,yc1,1)+ I1   +double(bwmorph(M1,'remove')); 
    Iall(xc1,yc1,2)=Iall(xc1,yc1,2)+I1    +double( bwmorph(M1,'remove'));
    Iall(xc1,yc1,3)=Iall(xc1,yc1,3)+I1;    
% imshow(I1); imshow(Iall); imshow(bwmorph(Mask21==coIN,'remove'))

    Iall(xc2,yc2,1)=Iall(xc2,yc2,1)+(255./255).*I2  +double(bwmorph(M1,'remove'));
    Iall(xc2,yc2,2)=Iall(xc2,yc2,2)+(25./255).*I2   +double(bwmorph(M1,'remove'));
    Iall(xc2,yc2,3)=Iall(xc2,yc2,3)+(0./255).*I2;

    Iall(xc3,yc3,1)=Iall(xc3,yc3,1)+(255./255).*I3 +double( bwmorph(M1,'remove'));
    Iall(xc3,yc3,2)=Iall(xc3,yc3,2)+(150./255).*I3 +double( bwmorph(M1,'remove'));
    Iall(xc3,yc3,3)=Iall(xc3,yc3,3)+(20./255).*I3;

    Iall(xc4,yc4,1)=Iall(xc4,yc4,1)+(25./255).*I4 +double( bwmorph(M1,'remove'));
    Iall(xc4,yc4,2)=Iall(xc4,yc4,2)+(173./255).*I4 +double( bwmorph(M1,'remove'));
    Iall(xc4,yc4,3)=Iall(xc4,yc4,3)+(255./255).*I4;

    Iall(xc5,yc5,1)=Iall(xc5,yc5,1)+(150./255).*I5 +double( bwmorph(M1,'remove'));
    Iall(xc5,yc5,2)=Iall(xc5,yc5,2)+(255./255).*I5 +double( bwmorph(M1,'remove'));
    Iall(xc5,yc5,3)=Iall(xc5,yc5,3)+(47./255).*I5;

f1=figure(1);
%set(gcf, 'Position', [15 50 1800 925]);% [ left bottom width height]
%get(0,'MonitorPositions');
%set(gcf, 'Position', [15 50 5760 1464]);% [ left bottom width height]
h1 = axes('Position',([0, 0, 1, 1] ));
imshow(Iall);hold on % imagesc(Inew_here(:,:));
% f1.WindowState('maximized')

% % declare time points to label the cell in frame
if itt==peak1
text(248,170,'pre-MI nuclear Rim11 peak','FontSize',current_font_size,'Color',[1,1,1])
text(328,140,'<=','FontSize',current_font_size,'Color',[1,1,1],'Rotation',270)
elseif  itt==MI
text(518,170,'Meiosis I','FontSize',current_font_size,'Color',[1,1,1])
text(548,140,'<=','FontSize',current_font_size,'Color',[1,1,1],'Rotation',270)
elseif itt==MII
text(518,170,'Meiosis II','FontSize',current_font_size,'Color',[1,1,1])
text(548,140,'<=','FontSize',current_font_size,'Color',[1,1,1],'Rotation',270)
elseif itt==M_completion
text(735,169,'Ume6 peak','FontSize',current_font_size,'Color',[1,1,1])
text(770,142,'<=','FontSize',current_font_size,'Color',[1,1,1],'Rotation',270)
end


unit=' h';
time_str0=['Phase']; col_here=[1,1,0];
text(7,17,time_str0,'FontSize',current_font_size,'Color',[1,1,1]); 
time_str1=['IME1pr-mRuby3']; col_here=[1,1,0];
text(236,17,time_str1,'FontSize',current_font_size,'Color',[1,1,1]); 
time_str1=['Rim11-mKOk']; col_here=[1,1,0];
text(456,17,time_str1,'FontSize',current_font_size,'Color',[1,1,1]); 
time_str1=['Ume6-mTFP']; col_here=[1,1,0];
text(673,17,time_str1,'FontSize',current_font_size,'Color',[1,1,1]); 
time_str1=['Ime1-mNeonGreen']; col_here=[1,1,0];
text(890,17,time_str1,'FontSize',current_font_size,'Color',[1,1,1]); 
time_str=['Time =' sprintf('%04.1f',time_ratio.*(itt-min(tim))) unit]; col_here=[1,1,0];

time_str=['Time =' sprintf('%04.1f',itt) unit]; col_here=[1,1,0];
text(7,34,time_str,'FontSize',current_font_size,'Color',col_here);
% time_str0=[ 'Cell no.' num2str(coIN2)]; col_here=[1,1,0];
% text(7,60,time_str0,'FontSize',current_font_size,'Color',col_here);

 hold on

tid_h=([min(tim):itt]-min(tim));
tid_h2=([min(tim):itt]-min(tim));

    Size=ALL_COMBO{1,2}(coIN2,min(tim):itt);    
    a12=Size;
    h1 = axes('Position',([0.05, 0.28, 0.14, 0.20] )); %[left bottom  width height]
    plot(tid_h2,a12,'color',[1 1 1]) ; %hold on
    plot(tid_h,a12(1:length(tid_h)),'linewidth',2.0,'color',[0 0 0]) ;%hold on
    text(5,345,'Cell Size','FontSize',10)
    ylim([270 350])
    xlim([min(tim) max(tim)]-min(tim))
    xlabel('time [h]',Color=[1 1 1])
    ylabel('Size [pixels]')

    % modify the axes manually 
    ax =gca;
    xticks(0:20:max(tim));
    curTick = ax.XTick;
    ax.XTickLabel = round((curTick)* time_ratio); 
    set(h1,'FontSize',8,'XColor',[1 1 1],'YColor',[1 1 1]);

% % % 
  %  Ime1pr - mRuby3
    Ime1pr=ALL_COMBO{73,2}(coIN2,min(tim):itt);
    a12=Ime1pr;
    h1 = axes('Position',([0.24, 0.28, 0.14, 0.20] ));%[left bottom  length height]
    plot(tid_h2,a12,'color',[1 1 1]) ; %hold on
    plot(tid_h,a12(1:length(tid_h)),'linewidth',2.0,'color',[1 0 0]) ;%hold on
    text(5,550,'Nuclear IME1pr-mRuby3','FontSize',10)
    ylim([0 600])
    xlim([min(tim) max(tim)]-min(tim))
    xlabel('time [h]')
    ylabel('Fluorescence [a.u.]')

    % modify the axes manually 
    ax =gca;
    xticks(0:20:max(tim));
    curTick = ax.XTick;
    ax.XTickLabel = round((curTick)* time_ratio); 
    set(h1,'FontSize',8,'XColor',[1 1 1],'YColor',[1 1 1]);

    % Rim11-mKok 
    Rim11=ALL_COMBO{10,2}(coIN2,min(tim):itt);
    a12=Rim11;
    h1 = axes('Position',([0.44, 0.28, 0.14, 0.20] ));%[left bottom  length height]
    plot(tid_h2,a12,'color',[1 1 1]) ; %hold on
    plot(tid_h,a12(1:length(tid_h)),'linewidth',2.0,'color',[1 0.7 0]) ;%hold on
    text(5,275,'Nuclear Rim11-mKok ','FontSize',10)
    ylim([0 300])
    xlim([min(tim) max(tim)]-min(tim))
    xlabel('time [h]')
    ylabel('Fluorescence [a.u.]')

    % modify the axes manually 
    ax =gca;
    xticks(0:20:max(tim));
    curTick = ax.XTick;
    ax.XTickLabel = round((curTick)* time_ratio); 
    set(h1,'FontSize',8,'XColor',[1 1 1],'YColor',[1 1 1]);

    % Ume6 - mTFP 
    Ume6=ALL_COMBO{52,2}(coIN2,min(tim):itt);
    a12=Ume6;
    h1 = axes('Position',([0.64, 0.28, 0.14, 0.20] ));%[left bottom  length height]
    plot(tid_h2,a12,'color',[1 1 1]) ; %hold on
    plot(tid_h,a12(1:length(tid_h)),'linewidth',2.0,'color',[0 0 1]) ;%hold on
    text(5,29,'Nuclear Ume6-mTFP','FontSize',10)
    ylim([15 30])
    xlim([min(tim) max(tim)]-min(tim))
    xlabel('time [h]')
    ylabel('Fluorescence [a.u.]')

    % modify the axes manually 
    ax =gca;
    xticks(0:20:max(tim));
    curTick = ax.XTick;
    ax.XTickLabel = round((curTick)* time_ratio); 
    set(h1,'FontSize',8,'XColor',[1 1 1],'YColor',[1 1 1]);


    % Ime1-mNG
    Ime1=ALL_COMBO{31,2}(coIN2,min(tim):itt);
    a12=Ime1;
    h1 = axes('Position',([0.84, 0.28, 0.14, 0.20] ));%[left bottom  length height]
    plot(tid_h2,a12,'color',[1 1 1]) ; %hold on
    plot(tid_h,a12(1:length(tid_h)),'linewidth',2.0,'color',[0 1 0]) ;%hold on
    text(5,49,'Nuclear Ime1-mNG','FontSize',10)
    ylim([30 50])
    xlim([min(tim) max(tim)]-min(tim))
    xlabel('time [h]')
    ylabel('Fluorescence [a.u.]')

    % modify the axes manually 
    ax =gca;
    xticks(0:20:max(tim));
    curTick = ax.XTick;
    ax.XTickLabel = round((curTick)* time_ratio); 
    set(h1,'FontSize',8,'XColor',[1 1 1],'YColor',[1 1 1]);





    if vid==1

% % loop though one frame to introduce a pause in the video

if itt==Rim11_peak || itt==MI || itt==MII || itt==Ume6_peak 


for iy=1:20
     currFrame = getframe(f1);
     writeVideo(vidObj,currFrame);
end

else

     currFrame = getframe(f1);
     writeVideo(vidObj,currFrame);


end

    else
     pause (0.005)   
    end

 %pause

end
 
if vid==1
close(vidObj);
end
close all

