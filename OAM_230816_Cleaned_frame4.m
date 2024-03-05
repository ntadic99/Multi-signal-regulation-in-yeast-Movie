function [I] = OAM_230816_Cleaned_frame4(path1,fname,y_cn,x_cn)



  I=double(imread([path1 fname]));% figure(1);imagesc(I1)
    I=medfilt2(I(y_cn,x_cn));
% 
%   I=(I-min(I(:)))./(max(I(:))-min(I(:)));
% %   BackG=median(I(:));
%    BackG=median(I(I~=0));
%   I=I-BackG;
%      
end
