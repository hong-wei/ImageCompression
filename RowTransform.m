function [ yy ] = RowTransform( data ,row,col)
%example: data_Trans_b= RowTransform(data_a,10,3);
%         row 10 ,col = 3;

yy = zeros(1,row); % 维度自己设定。

for j=1:col;
    %multiply by the H
    x=data(j,1:row);
    H=[1,1;1,-1];
    y=[];
    y_L=[];
    y_H=[];
    for i= 1:2:length(x)-1;
        y0=[x(i),x(i+1)]*H;
        y=[y,y0];
    end;

    % change the place 
    for i=1:2:length(y);
        y_L=[y_L,y(i)];  %change the place of Low  frequence
        y_H=[y_H,y(i+1)];%change the plave of High frequence
    end;

    y_L_H= [y_L,y_H];
    yy(j,:)=y_L_H;
end;


end

