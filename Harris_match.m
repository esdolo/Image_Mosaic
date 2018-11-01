% by WQT 2018/10/27
% wangqt16@mails.tsinghua.edu.cn 2016011399
%
% Function: receive 2 img, detect and match Harris points.
% Input:    img1/2    
% Ouput:   matchedPoints1/2 : coordinates of matched point pair
function [matchedPoints1,matchedPoints2] = Harris_match(img1,img2)

        img1 = rgb2gray(img1);
        img2 = rgb2gray(img2);

    points1 = detectHarrisFeatures(img1);
    points2 = detectHarrisFeatures(img2);
    
    points1=points1.selectStrongest(600);
    points2=points2.selectStrongest(600);
    
    [features1,valid_points1] = extractFeatures(img1,points1);
    [features2,valid_points2] = extractFeatures(img2,points2);
    
    indexPairs = matchFeatures(features1,features2);
    
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);
end