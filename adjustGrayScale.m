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
%ֱ��ͼ���⻯  
[height,width] = size(I);  
% figure  
% subplot(221)  
% imshow(I)%��ʾԭʼͼ��  
% subplot(222)  
% imhist(I)%��ʾԭʼͼ��ֱ��ͼ  

%�������ػҶ�ͳ��;  
s = zeros(1,101);%ͳ�Ƹ��Ҷ���Ŀ����100���Ҷȼ�  (0.01һ��)
for i = 1:height  
    for j = 1: width  
%         if(round(I(i,j)/0.01)~=100)
        s(round(I(i,j)/0.01) + 1) = s(round(I(i,j)/0.01) + 1) + 1;%��Ӧ�Ҷ�ֵ���ص���������һ  
%         else
%         s(85)=s(85)+1;
%         end
    end         
end    
%����Ҷȷֲ��ܶ�  
p = zeros(1,101);  
for i = 1:101  
    p(i) = s(i) / (height * width * 1.0);  
end  
%�����ۼ�ֱ��ͼ�ֲ�  
c = zeros(1,101);  
c(1) = p(1);
for i = 2:101  
        c(i) = c(i - 1) + p(i);  
end  
%�ۼƷֲ�ȡ��,������ֵ��һ��Ϊ1~256 
c = (0.01*round(100 .* c));  
%��ͼ����о��⻯
for i = 1:height  
    for j = 1: width  
        I(i,j) = c(round(I(i,j)/0.01)+1);  
    end  
end  

% subplot(223)  
% imshow(I)%��ʾ���⻯���ͼ��
% subplot(224)  
% imhist(I)%����ʾ���⻯���ͼ���ֱ��ͼ
img1_adj=I;
end



