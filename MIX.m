function [ img2 , index] = MIX( datasets,img2 )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
siz=size(datasets);
max_matchpoints=0;
for i=1:siz
    [p1,p2]=Harris_match(datasets{i},img2);
    n=size(p1.Location);
    if n>max_matchpoints
        max_matchpoints=n;
        index=i;
    end
end
 img1=datasets{index};
 [p1,p2]=Harris_match(img1,img2);
 figure; ax = axes;
 showMatchedFeatures(img1,img2,p1,p2,'montage','Parent',ax);
 title(ax, 'Candidate point matches');
 legend(ax, 'Matched points 1','Matched points 2');
 H=ransac_est(p1,p2,10);
 [ img2,~ ] = image_blending( img1,img2,H );
 imshow(img2);
 
end

