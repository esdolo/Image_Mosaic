% by WQT 2018/10/27
% wangqt16@mails.tsinghua.edu.cn 2016011399
%
% Function: Adjust average gray scale of img1, make it similar to img2 (main on white wall part)
% Input:   img1/2,
% Output:   img_1 (adjusted)
function [ img1_adj  ] =  adjustGrayScale(img1)
img1_adj(:,:,1)=adjustGrayScale_single( img1(:,:,1) );
img1_adj(:,:,2)=adjustGrayScale_single( img1(:,:,2) );
img1_adj(:,:,3)=adjustGrayScale_single( img1(:,:,3) );
end


function [ img1_adj ] = adjustGrayScale_single( I )
%ֱ��ͼ���⻯  
[height,width] = size(I);  
% figure  
% subplot(221)  
% imshow(I)%��ʾԭʼͼ��  
% subplot(222)  
% imhist(I)%��ʾԭʼͼ��ֱ��ͼ  
gmax=max(I(:));
step=floor(gmax*100)*0.0001;
%�������ػҶ�ͳ��;  
s = zeros(1,101);%ͳ�Ƹ��Ҷ���Ŀ����100���Ҷȼ�  (0.01һ��)
for i = 1:height  
    for j = 1: width  
        if floor(I(i,j)/step) + 1>101||floor(I(i,j)/step) + 1<1
        continue;
        end

        s(floor(I(i,j)/step) + 1) = s(floor(I(i,j)/step) + 1) + 1;%��Ӧ�Ҷ�ֵ���ص���������һ  
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
%c = (step*round(gmax*100 .* c));  
c = (gmax .* c);  
%��ͼ����о��⻯
for i = 1:height  
    for j = 1: width  
        I(i,j) = c(round(I(i,j)/step)+1);  
    end  
end  

% subplot(223)  
% imshow(I)%��ʾ���⻯���ͼ��
% subplot(224)  
% imhist(I)%����ʾ���⻯���ͼ���ֱ��ͼ
img1_adj=I;
end



