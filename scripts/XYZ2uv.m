function [u,v] = XYZ2uv(X,Y,Z,offset,pmatrix1,pmatrix2,pmatrix3)
% local 3D coordinate
PointX=X-offset{1};
PointY=Y-offset{2};
PointZ=Z-offset{3};

M=[PointX;PointY;PointZ;1];
pic_x=pmatrix1*M; 
pic_y=pmatrix2*M; 
pic_z=pmatrix3*M; 

u=round(pic_x/pic_z); 
v=round(pic_y/pic_z); 
end
