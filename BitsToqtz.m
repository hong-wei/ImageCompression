function [ output_args ] = BitsToqtz( input_args ,N)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(input_args(:,1))
    b_qtz_8=[];
    if(input_args(i,1)==0)
        b_qtz_8=bi2de((input_args(i,2:N)));
    else
        b_qtz_8=-bi2de((input_args(i,2:N)));
    end
    output_args(i) = b_qtz_8;
end

end

