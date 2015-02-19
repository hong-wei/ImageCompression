function [ output_args] = HuffmanToBits( qtz_N,huff_arr,huff_number,huff_leng )

qtz_huff_bits=[];
for i = 1:length(qtz_N)
    for(j=1:length(huff_number))
        if(qtz_N(i)==huff_number(j))
            qtz_huff_bits=[qtz_huff_bits,floor(huff_arr(j,length(huff_arr(1,:))+1-huff_leng(j):length(huff_number)))];  
        end
    end
end

output_args= qtz_huff_bits;
end

