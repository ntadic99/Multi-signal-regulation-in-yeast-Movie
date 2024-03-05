
function [I] = OAM_230816_Cleaned_frame_noBack4(path1, fname,y_cn,x_cn)

  I=double(imread([path1 fname]));% figure(1);imagesc(I1)
  I=I(y_cn,x_cn);
%   I=medfilt2(I(up1:down1,left1:right1));
  I=(I-min(I(:)))./(max(I(:))-min(I(:)));
%   BackG=median(I(:));
%    BackG=median(I(I~=0));
%   I=I-BackG;
% %      
end


