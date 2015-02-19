function [] = WritePgm( input_args ,Name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[rows, cols] = size(input_args);

% Convert into PGM imagefile, readable by "keypoints" executable
f = fopen(['eg2014_new_',num2str(Name),'.pgm'], 'w');
if f == -1
    error('Could not create file tmp.pgm.');
end
fprintf(f, 'P5\n%d\n%d\n255\n', cols, rows);
fwrite(f, input_args', 'uint8');
fclose(f);

end




