function [ output_args ] = BitsToHuffman( d_read_1,d_huff_number,d_huff_arr,d_huff_leng )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

huffman_bit=[];
d_read_6=[];
m=1;
for i=1:length(d_read_1)  
    huffman_bit=[huffman_bit,d_read_1(i)];
    for j=1:length(d_huff_number)
        if(isequal(huffman_bit,d_huff_arr(j,(length(d_huff_number)+1-d_huff_leng(j):length(d_huff_number)))))
            huffman_bit=[];
            d_read_6(m)=d_huff_number(j);
            m=m+1;
        end
    end;
end;

output_args=d_read_6';
end

