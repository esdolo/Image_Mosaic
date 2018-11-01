% by WQT 2018/10/27
% wangqt16@mails.tsinghua.edu.cn 2016011399
%
% Function: blending 2 img with H:1->2. wrap img1 to img2. call wraped img1
% as img_r.
% Input:   img1/2,H
% Output:   img_blend
%
%  ->->->->->Y
%  |
%  |
%  |
%  X
function [ img_b,old_centre ] = image_blending( img1,img2,H )

[ img_b ,old_centre] = image_widen( img1,img2,H );
siz=size(img_b);
siz_origin=size(img1);
%[x_b,y_b]=meshgrid(1:siz(1),1:siz(2));
[y_b,x_b]=meshgrid(1:siz(1),1:siz(2));
x_b=x_b(:);y_b=y_b(:);
T_1tob=ones(3,siz(1)*siz(2));
T_1tob(1,:)=x_b(:)-old_centre(1);
T_1tob(2,:)=y_b(:)-old_centre(2);
T_1tob=inv(H)*T_1tob;
T_1tob(1,:)=round(T_1tob(1,:)./T_1tob(3,:));
T_1tob(2,:)=round(T_1tob(2,:)./T_1tob(3,:));

for q=1:siz(1)*siz(2)
    if(T_1tob(1,q)<1||T_1tob(1,q)>siz_origin(1)||T_1tob(2,q)<1||T_1tob(2,q)>siz_origin(2))
        continue;
    end
    if(img_b(y_b(q),x_b(q),1)~=0) 
        continue;
    end
    for k=1:3
%      disp(T_1tob(1,q));
%      disp(T_1tob(2,q));
%      disp(x_b(q));
%      disp(y_b(q));
    img_b(y_b(q),x_b(q),k)=img1(T_1tob(2,q),T_1tob(1,q),k);
    %disp(img1(T_1tob(1,q),T_1tob(2,q),k));
    end
end
imshow(img_b);

[newH, newW, newX, newY, xB, yB] = getNewSize(inv(H), 640, 640, 640, 640);
[X,Y] = meshgrid(1:640,1:640);
[XX,YY] = meshgrid(newX:newX+newW-1, newY:newY+newH-1);
AA = ones(3,newH*newW);
AA(1,:) = reshape(XX,1,newH*newW);
AA(2,:) = reshape(YY,1,newH*newW);

AA = inv(H)*AA;
XX = reshape(AA(1,:)./AA(3,:), newH, newW);
YY = reshape(AA(2,:)./AA(3,:), newH, newW);

% XX（i），YY(j)： 新图像上每一点（i,j）对应原图像上XX（i），YY(j)点。
% INTERPOLATION, WARP IMAGE A INTO NEW IMAGE
newImage(:,:,1) = interp2(X, Y, double(img1(:,:,1)), XX, YY);
newImage(:,:,2) = interp2(X, Y, double(img1(:,:,2)), XX, YY);
newImage(:,:,3) = interp2(X, Y, double(img1(:,:,3)), XX, YY);
img_b=newImage;
imshow(img_b);

function [ img_b,old_centre ] = image_widen( img1,img2,H )
% determine the size of combined image
    img_b=img2;
    siz1=size(img1);siz2=size(img2);
    w1=siz1(1);h1=siz1(2);w2=siz2(1);h2=siz2(2);
    
    corner_r=[H*[1,1,1]',H*[w1,1,1]',H*[1,h1,1]',H*[w1,h1,1]']';
    for i=1:4
         corner_r(i,1:2)=corner_r(i,1:2)/corner_r(i,3);
    end
    
%     corner_r=sortrows(corner_r,1);
%     corner_u=sortrows(corner_r(1:2,:),2);corner_d=sortrows(corner_r(3:4,:),2);
%     ul=corner_u(1,:);% up;dowm;left;right corner
%     ur=corner_u(2,:);
%     dl=corner_d(1,:);
%     dr=corner_d(2,:);
%     
    corner_r=sortrows(corner_r,1);
    temp=corner_r(1,:);
    x_min=temp(2);% x min
    temp=corner_r(4,:);
    x_max=temp(2);% x max
    corner_r=sortrows(corner_r,2);
    temp=corner_r(1,:);
    y_min=temp(1);% y min
    temp=corner_r(4,:);
    y_max=temp(1);% y max
    
    old_centre=ones(2,1);
    if x_min<=0
        img_b = padarray(img_b, [round(-x_min+10), 0], 'pre');
        old_centre(1)=round(-x_min+10);
    end
    if x_max>h2
        img_b = padarray(img_b, [round(x_max-h2+10), 0], 'post');
    end
    if y_min<=0
        img_b = padarray(img_b, [0,round(-y_min+10)], 'pre');
        old_centre(2)=round(-y_min+10);
    end
    if y_max>w2
        img_b = padarray(img_b, [0,round(y_max-w2+10)], 'post');
    end
end
end
function [newH, newW, x1, y1, x2, y2] = getNewSize(transform, h2, w2, h1, w1)
% Calculate the size of new mosaic
% Input:
% transform - homography matrix
% h1 - height of the unwarped image
% w1 - width of the unwarped image
% h2 - height of the warped image
% w2 - height of the warped image
% Output:
% newH - height of the new image
% newW - width of the new image
% x1 - x coordate of lefttop corner of new image
% y1 - y coordate of lefttop corner of new image
% x2 - x coordate of lefttop corner of unwarped image
% y2 - y coordate of lefttop corner of unwarped image
% 
% Yihua Zhao 02-02-2014
% zhyh8341@gmail.com
%

% CREATE MESH-GRID FOR THE WARPED IMAGE
[X,Y] = meshgrid(1:w2,1:h2);
AA = ones(3,h2*w2);
AA(1,:) = reshape(X,1,h2*w2);
AA(2,:) = reshape(Y,1,h2*w2);

% DETERMINE THE FOUR CORNER OF NEW IMAGE
newAA = transform\AA;
new_left = fix(min([1,min(newAA(1,:)./newAA(3,:))]));
new_right = fix(max([w1,max(newAA(1,:)./newAA(3,:))]));
new_top = fix(min([1,min(newAA(2,:)./newAA(3,:))]));
new_bottom = fix(max([h1,max(newAA(2,:)./newAA(3,:))]));

newH = new_bottom - new_top + 1;
newW = new_right - new_left + 1;
x1 = new_left;
y1 = new_top;
x2 = 2 - new_left;
y2 = 2 - new_top;
end


