% by WQT 2018/10/27
% wangqt16@mails.tsinghua.edu.cn 2016011399
% 

directory = 'img/';
files = dir(directory);
files = files(2:end);

N = numel(files);
dataset = {};
cnt = 1;
for i = 1:N
    if files(i).name(1) ~= '.'
    im = imread(strcat(directory,files(i).name));
    %im = double(imrotate(imresize(im, [640, 640]), -90))/255;
     im = double(imresize(im, [640, 640]))/255;
    dataset{cnt} = im;
    imshow(im);
    drawnow;
    cnt = cnt + 1;
    end
end

tic
img1=dataset{4};img2=dataset{5};
[p1,p2]=Harris_match(img1,img2);
toc
'角点检测结束'

 figure; ax = axes;
 showMatchedFeatures(img1,img2,p1,p2,'montage','Parent',ax);
 title(ax, 'Candidate point matches');
 legend(ax, 'Matched points 1','Matched points 2');

tic
H=ransac_est(p1,p2,10);
%[H, inlier_ind] = ransac_est_homography(p1.Location(1,:), p1.Location(2,:),p2.Location(1,:),p2.Location(2,:),20);
toc
'矩阵RANSAC计算结束'

%**************直接用已有的****************
%H=[0.866660837378654,0.002136523043820,1.304511246541155e+02;-0.061314288503895,0.960245712418742,10.797841342902883;-2.206662137496741e-04,1.186921678112597e-05,1];
%H=inv(H);
%*******************************************

'矩阵正逆：'
disp(H);
HV=inv(H);
disp(HV);


tic
[ img_b,old_centre ] = image_blending( img1,img2,H );
toc
'blending结束'

imshow(img_b);



% 正向warp
% img_x=zeros(800,800,3);
% for i=1:640
%     for j=1:640
%         c=H*[i,j,1]';
%         c=c/c(3);
%         for k=1:3
%         img_x(round(c(1))+100,round(c(2))+100,k)=img1(i,j,k);
%         end
%     end
% end
% 
% siz=size(img_b);
% img_b2=zeros(siz);
% for i=1:siz(1)
%     for j=1:siz(2)
%         c=HV*[i-old_centre(1),j-old_centre(2),1]';
%         c=c/c(3);
%         if(c(1)>0&&c(1)<638&&c(2)>0&&c(2)<638)
%         for k=1:3
%         img_b2(i,j,k)=img1(round(c(1)+1),round(c(2)+1),k);
%         end
%         end
%     end
% end
% 
% subplot(1,2,1);imshow(img_b);
% subplot(1,2,2);
% imshow(img_b2);





