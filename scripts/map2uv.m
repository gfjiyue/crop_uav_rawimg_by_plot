function [uv] = map2uv(dx,dy,x0,y0,mapx0,mapyn,mapx,mapy)
x=roundn(((mapx-mapx0)/dx+x0),-1);
y=roundn(((mapyn-mapy)/dy+y0),-1);
indx=find(x~=fix(x));
x(indx)=round(abs(x(indx)-0.5))+0.5;
indy=find(y~=fix(y));
y(indy)=round(abs(y(indy)-0.5))+0.5;   
uv=[round(y+y0)',round(x+x0)'];
end
