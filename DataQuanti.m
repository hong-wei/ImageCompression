function [ output_args ] = DataQuanti(input_args,DivideBits)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

output_args= round(input_args/DivideBits);
output_args=output_args(:);

% b = reshape(f_qtz_4,384,1024); go back the function
end
