function [miu, sigm] = OAM_230816_Zinorm_vid4(path1, fname,numbF,y_cn,x_cn)

% path1=Pat_s;
% fname=fileNames1{itt};
% numbF=189;

znorm=zeros(numbF,2);

for itt=1:numbF%length(fileNames1)%

I1=OAM_230816_Cleaned_frame4(path1,fname,y_cn,x_cn);
znorm(itt,1)=mean(I1(:));
znorm(itt,2)=std(I1(:));

end

miu =mean(znorm(:,1));
sigm=mean(znorm(:,2));


