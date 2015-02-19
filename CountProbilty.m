function [ output_args ,huff_number] = CountProbilty( input_args)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

output_args=[zeros(1,100)];
N=1-(min(input_args));
for i=min(input_args):max(input_args)
    huff_number(i+N)= i;
    for j=1:length(input_args)
        if(input_args(j)==(i))
            output_args(i+N)= output_args(i+N)+1;
        end  
    end
end 

output_args=output_args/length(input_args);

end

