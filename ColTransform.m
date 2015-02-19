function [ yy_col ] = ColTransform( data ,row,col)
%example: data_Trans_b= CowTransform(data_a,10,3);
%         row 10 ,col = 3;

yy = zeros(1,col); % 维度自己设定。

data_col= data';
row_col= col;
col_col =row;

yy= RowTransform(data_col,row_col,col_col);

yy_col = yy';


end

