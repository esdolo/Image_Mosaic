% by WQT 2018/10/27
% wangqt16@mails.tsinghua.edu.cn 2016011399
%
% Function: estimate transformation 1 -> 2 matrix F(3x3)  by 4-point homography;
%            (with at least 4 point)
% Input:    match_point 1/2  x4 pairs
% Output:   F (3x3)
function [F] = est_transformation(points1,points2)
A=zeros(2*length(points1),9);         % 
for i=1:length(points1)
    %A(i*2-1:i*2,1:9)=[ [[points1(i,1),points1(i,2),1] [0,0,0];[0,0,0] [points1(i,1),points1(i,2),1]]  -[points2(i,1);points2(i,2)]*[points1(i,1),points1(i,2),1] ];
 a = [points1(i,1),points1(i,2),1];
 b = [0 0 0];
 c = [points2(i,1);points2(i,2)];
 d = -c*a;
 A((i-1)*2+1:(i-1)*2+2,1:9) = [[a b;b a] d];
    %reference : ÊÓ¾õSLAM @¸ßÏè P147
end
[~,~,V]=svd(A);
F=V(:,9);
F=reshape(F,3,3)'; 
end