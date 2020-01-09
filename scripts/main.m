%% import orthomosaic,shapefile,photo,M path
clear;
ROOT = 'D:\plot_crop_in_rawuavimg\samples\';
name = dir([ROOT,'pix4D\']);
name = cell2mat({name(3:end).name}');
Plotpath=[ROOT,'plot\'];
Outpath=[ROOT,'output_csv\'];

%% //////////////// run /////////////////////////////
for nm=1:size(name,1)
    
% import files
Orthoimgpath = [ROOT,'pix4D\',name(nm,:),'\'];
DSMpath = [ROOT,'pix4D\',name(nm,:),'\'];
Pmatrixpath = [ROOT,'pix4D\',name(nm,:),'\'];
offsetpath = [ROOT,'pix4D\',name(nm,:),'\'];
Photopath=[ROOT,'rawRGB\',name(nm,:),'\'];

Orthoimgfile=dir(fullfile(Orthoimgpath, '*mosaic_group1.tif'));
DSMfile=dir(fullfile(DSMpath, '*dsm.tif'));
Pmatrixfile=dir(fullfile(Pmatrixpath, '*pmatrix.txt'));
offsetfile=dir(fullfile(offsetpath, '*offset.xyz'));
Photofile=dir(fullfile(Photopath, '*.jpg'));
Plotfile=dir(fullfile(Plotpath, '*.shp'));

[IMG,R1]=geotiffread([Orthoimgfile.folder,'\',Orthoimgfile.name]);
[DSM,R2]=geotiffread([DSMfile.folder,'\',DSMfile.name]);
Plot=shaperead([Plotfile.folder,'\',Plotfile.name]);
[photoid,pmatrix1,pmatrix2,pmatrix3] = ReadPmatrix(Pmatrixfile);
str=cell2mat({Photofile.name}');
id=[str2num(str(:,5:8))];
[C,ia,ib] = intersect(id,photoid,'rows');
Photofile=Photofile(ia);
offsetid=fopen([offsetfile.folder,'\',offsetfile.name]);
offset=textscan(offsetid,'%f %f %f');
fclose(offsetid);
photoinfo=imfinfo([Photopath,'\',Photofile(1).name]);

% start calculate and validate
n=1;
Table(n).plot=[];
Table(n).photoin='';

for i=1:size(Plot,1)

X=(Plot(i).X(1:4));
Y=(Plot(i).Y(1:4));
 
dx=R2.CellExtentInWorldX;
dy=R2.CellExtentInWorldY;
x0=R2.XIntrinsicLimits(1);
y0=R2.YIntrinsicLimits(1);
mapx0=R2.XWorldLimits(1);
mapyn=R2.YWorldLimits(2);
Zuv = map2uv(dx,dy,x0,y0,mapx0,mapyn,X,Y);
ZZ=DSM(Zuv(:,1),Zuv(:,2));
Z=ones(4,1).*max(diag(ZZ));

u=zeros(4,1);
v=zeros(4,1);
H=zeros(4,1);

for j=1:size(Photofile,1)
 for p=1:4
    [u(p),v(p)] = XYZ2uv(X(p),Y(p),Z(p),offset,pmatrix1(j,:),pmatrix2(j,:),pmatrix3(j,:));
    H(p)=((u(p)>0).*(u(p)<=photoinfo.Width).*(v(p)>0).*(v(p)<=photoinfo.Height)==1);
 end

 if sum(H)==4
    Table(n).plot=Plot(i).Plot;
    Table(n).photoin=[Table(n).photoin,Photofile(j).name];
    Table(n).coords=[u,v];
    n=n+1;
 end
end
end
%% ///////////////// output ///////////////////////////////
writetable(struct2table(Table), [Outpath,name(nm,:),'_plot_image.csv']);
clear Table
end

