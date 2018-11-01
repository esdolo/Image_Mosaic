function [ img2 ] = MIX_selected( img1,img2 )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
 [p1,p2]=Harris_match(img1,img2);
 figure; ax = axes;
 showMatchedFeatures(img1,img2,p1,p2,'montage','Parent',ax);
 title(ax, 'Candidate point matches');
 legend(ax, 'Matched points 1','Matched points 2');
 H=ransac_est(p1,p2,10);
 [ img2,~ ] = image_blending( img1,img2,H );
 imshow(img2);
 
end