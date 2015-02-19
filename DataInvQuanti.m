function [ output_args ] = DataInvQuanti( input_args ,DivideBits,Row,Col)

Data_one_row= round(input_args*DivideBits);

output_args= reshape(Data_one_row,Row,Col);

end

