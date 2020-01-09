function [photoid,pmatrix1,pmatrix2,pmatrix3] = ReadPmatrix(Pmatrixfile)

Pmatrixid=fopen([Pmatrixfile.folder,'\',Pmatrixfile.name]);
Pmatrix=textscan(Pmatrixid,'DJI_%4d .JPG%f %f %f %f %f %f %f %f %f %f %f %f');
photoid=[Pmatrix{1,1}];
pmatrix1=[Pmatrix{1,2},Pmatrix{1,3},Pmatrix{1,4},Pmatrix{1,5}];
pmatrix2=[Pmatrix{1,6},Pmatrix{1,7},Pmatrix{1,8},Pmatrix{1,9}];
pmatrix3=[Pmatrix{1,10},Pmatrix{1,11},Pmatrix{1,12},Pmatrix{1,13}];
fclose(Pmatrixid);
end
