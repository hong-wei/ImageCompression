function [ image ] = ReadPgm( PgmPath )
% pgm_image_name='tmp.pgm';
% data =ReadPgm(pgm_image_name);
%  

f = fopen(PgmPath);
imgsize=fscanf(f, 'P5\n%d\n%d\n255\n');

image=[];
for h=1:imgsize(2)
    image=[image fread(f,imgsize(1),'uint8')];
end

image=image.';
fclose(f);


end

