function [ yy ] = RowInveTransform( data ,row,col )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
yy = zeros(1,row); % 维度自己设定。

for j=1:col;
    %change the place 
    y_L_H=data(j,1:row);
    x=[];
    for i=1:1:length(y_L_H)/2;
        x=[x,y_L_H(i)];  %change the place of Low  frequence
        x=[x,y_L_H(i+length(y_L_H)/2)];%change the plave of High frequence
    end;
    
    %multiply by the H
    H=[1/2,1/2;1/2,-1/2];
    y=[];
    y_L=[];
    y_H=[];
    for i= 1:2:length(x)-1;
        y0=[x(i),x(i+1)]*H;
        y=[y,y0];
    end;
    yy(j,:)= y;

    
end;

end

