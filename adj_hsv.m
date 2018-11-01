function [ data_adj ] = adj_hsv( dataset )
siz=size(dataset);
siz=siz(2);
data_adj={};
hsv={};
s=zeros(siz,1);
for i=1:siz
    hsv{i}=rgb2hsv(dataset{i});
    s(i)=calsum(hsv{i});
end

s=s/s(1);%计算相对亮度系数
data_adj{1}=dataset{1};

for i=2:siz
hsv{i}(:,:,3)=hsv{i}(:,:,3)./s(i);
data_adj{i}=hsv2rgb(hsv{i});
end
end
function [s]=calsum(hsv)
%计算总亮度
v1=hsv;
v1=v1(:,:,3);
v1=v1(:);
s=sum(v1);    
end
