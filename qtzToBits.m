function [ output_args ] = qtzToBits( input_args ,N)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
flag1 = min(input_args);
qtz_bits=[];
if(flag1>0)
    for i=1:length(input_args)
        qtz_bits = [qtz_bits,(de2bi(input_args(i),N))];
    end
else
    for i = 1:length(input_args)
        b_qtz_8=[];
        b_qtz_7_1=de2bi(abs(input_args(i)),N-1);
        if(input_args(i)>=0)
            b_qtz_8=[0,b_qtz_7_1];
        else
            b_qtz_8=[1,b_qtz_7_1];
        end 
        
        qtz_bits = [qtz_bits,b_qtz_8];
    end
end
     
     
output_args=qtz_bits;
end

