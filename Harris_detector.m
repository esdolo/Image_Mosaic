% by WQT 2018/10/27
% wangqt16@mails.tsinghua.edu.cn 2016011399
%
% Function: receive 2 img, detect and match Harris points.
% INPUT:    img1/2    
% OUTPUT:   matchedPoints1/2 : coordinates of matched point pair
function [matchedPoints1,matchedPoints2] = Harris_match(img1,img2)
    if size(img1, 3) > 1
        img1 = rgb2gray(img1);
    end
    if size(img2, 3) > 1
        img2 = rgb2gray(img2);
    end
    points1 = detectHarrisFeatures(img1);
    points2 = detectHarrisFeatures(img2);
    
    points1=points1.selectStrongest(200);
    points2=points2.selectStrongest(200);
    
    [features1,valid_points1] = extractFeatures(I1,points1);
    [features2,valid_points2] = extractFeatures(I2,points2);
    
    indexPairs = matchFeatures(features1,features2);
    
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);
end