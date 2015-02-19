function [ yy_col ] = ColInveTransform( data ,row,col)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

yy = zeros(1,col); % 维度自己设定。

data_col= data';
row_col= col;
col_col =row;

yy= RowInveTransform(data_col,row_col,col_col);

yy_col = yy';

end

