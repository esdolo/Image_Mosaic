% by WQT 2018/10/27
% wangqt16@mails.tsinghua.edu.cn 2016011399
%
% Function: Adjust average gray scale of img1, make it similar to img2 (main on white wall part)
% Input:   img1/2,
% Output:   img_1 (adjusted)
function [ img1_adj  ] =  adjustGrayScale(img1)
temp=img1(:,:,1);
m=max(temp(:));
img1_adj(:,:,1)=adjustGrayScale_single( img1(:,:,1)./m );
img1_adj(:,:,1)=img1_adj(:,:,1).*m;

temp=img1(:,:,2);
m=max(temp(:));
img1_adj(:,:,2)=adjustGrayScale_single( img1(:,:,2)./m );
img1_adj(:,:,2)=img1_adj(:,:,2).*m;

temp=img1(:,:,3);
m=max(temp(:));
img1_adj(:,:,3)=adjustGrayScale_single( img1(:,:,3)./m );
img1_adj(:,:,3)=img1_adj(:,:,3).*m;
end


function [ img1_adj ] = adjustGrayScale_single( I )
%直方图均衡化  
[height,width] = size(I);  
% figure  
% subplot(221)  
% imshow(I)%显示原始图像  
% subplot(222)  
% imhist(I)%显示原始图像直方图  

%进行像素灰度统计;  
s = zeros(1,101);%统计各灰度数目，共100个灰度级  (0.01一级)
for i = 1:height  
    for j = 1: width  
%         if(round(I(i,j)/0.01)~=100)
        s(round(I(i,j)/0.01) + 1) = s(round(I(i,j)/0.01) + 1) + 1;%对应灰度值像素点数量增加一  
%         else
%         s(85)=s(85)+1;
%         end
    end         
end    
%计算灰度分布密度  
p = zeros(1,101);  
for i = 1:101  
    p(i) = s(i) / (height * width * 1.0);  
end  
%计算累计直方图分布  
c = zeros(1,101);  
c(1) = p(1);
for i = 2:101  
        c(i) = c(i - 1) + p(i);  
end  
%累计分布取整,将其数值归一化为1~256 
c = (0.01*round(100 .* c));  
%对图像进行均衡化
for i = 1:height  
    for j = 1: width  
        I(i,j) = c(round(I(i,j)/0.01)+1);  
    end  
end  

% subplot(223)  
% imshow(I)%显示均衡化后的图像
% subplot(224)  
% imhist(I)%显显示均衡化后的图像的直方图
img1_adj=I;
end



