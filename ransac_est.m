% by WQT 2018/10/27
% wangqt16@mails.tsinghua.edu.cn 2016011399
%
% Function: estimate transformation 1 -> 2 matrix F(3x3)  by ransac, 
% using est_transformation()
% Input:   all match_point; inlier_range as thresold of judging inliers by
% SSD
% Output:   F (3x3)
function [H] = ransac_est(points1,points2,inlier_range)
 p1=points1.Location;
 p2=points2.Location;
 len=length(p1);
 H=zeros(3,3);
 max_count=0;
for i=1:666
    r = randi([1, len], 4, 1);
    random_p1=p1(r,:);
    random_p2=p2(r,:);
    H_i=est_transformation(random_p1,random_p2);%calculate H_i by random point-pair x4
%    HV=inv(H_i);
%     random_p1=ones(3,8);
%     random_p2=ones(3,8);
%     random_p1(1:2,:)=p1(r,:)';
%     random_p2(1:2,:)=p2(r,:)';
%     H_i=getHomographyMatrix(random_p1, random_p2, 8);
    
    %calculate inlier num. set H_i with most inliers as H
    count=0;
    for j=1:len
        P1to2=H_i*[p1(j,:)'; 1];
        P1to2=P1to2(1:2)/P1to2(3);
        temp=[p2(j,:)']-P1to2;
        S_error=abs(temp'*temp);
        if S_error<=inlier_range 
            count=count+1;
        end  
    end
    if(count>max_count)
        max_count=count;
        H=H_i;
    end
end
end

function [hh] = getHomographyMatrix(point_ref, point_src, npoints)
% Use corresponding points in both images to recover the parameters of the transformation 
% Input:
% x_ref, x_src --- x coordinates of point correspondences
% y_ref, y_src --- y coordinates of point correspondences
% Output:
% h --- matrix of transformation

% NUMBER OF POINT CORRESPONDENCES
x_ref = point_ref(1,:)';
y_ref = point_ref(2,:)';
x_src = point_src(1,:)';
y_src = point_src(2,:)';

% COEFFICIENTS ON THE RIGHT SIDE OF LINEAR EQUATIONS
A = zeros(npoints*2,8);
A(1:2:end,1:3) = [x_ref, y_ref, ones(npoints,1)];
A(2:2:end,4:6) = [x_ref, y_ref, ones(npoints,1)];
A(1:2:end,7:8) = [-x_ref.*x_src, -y_ref.*x_src];
A(2:2:end,7:8) = [-x_ref.*y_src, -y_ref.*y_src];

% COEFFICIENT ON THE LEFT SIDE OF LINEAR EQUATIONS
B = [x_src, y_src];
B = reshape(B',npoints*2,1);

% SOLVE LINEAR EQUATIONS
h = A\B;

hh = [h(1),h(2),h(3);h(4),h(5),h(6);h(7),h(8),1];
end