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
    %imshow(im);
    %drawnow;
    cnt = cnt + 1;
    end
end


img1=dataset{1};img2=dataset{4};
tic
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

% '矩阵正逆：'
% disp(H);
% HV=inv(H);
% disp(HV);
% 

tic
[ img_b,old_centre ] = image_blending( img1,img2,H );
toc
'blending结束'

imshow(img_b);

img23=MIX_selected(dataset{2},dataset{3});
imshow(img23);
img56=MIX_selected(dataset{5},dataset{6});
imshow(img56);
img78=MIX_selected(dataset{7},dataset{8});
imshow(img78);
img789=MIX_selected(dataset{9},img78);
imshow(img789);
img1234=MIX_selected(img_b,img23);
imshow(img1234);
img56789=MIX_selected(img56,img789);
imshow(img56789);
img123456789=MIX_selected(img1234,img56789);
imshow(img123456789);
imwrite(img123456789,'img123456789.jpg');


% newimg=img_b;
% for i=2:9
% [newimg,del]=MIX(dataset,newimg);
% dataset(del)=[];
% imshow(newimg);
% end
% imwrite(newimg,'MixedImg.jpg');




