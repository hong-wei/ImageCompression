function [ output_args,fuff_leng] = HuffmanArray( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

p=input_args;
n=length(p);
q=p;
a=zeros(n-1,n);                        
for i=1:n-1  
   [q,l]=sort(q);                      
   a(i,:)=[l(1:n-i+1),zeros(1,i-1)];  
   q=[q(1)+q(2),q(3:n),1];             
end  

for i=1:n-1  
   c(i,1:n*n)=blanks(n*n); 
end  

c(n-1,n)='0';            
c(n-1,2*n)='1';        

for i=2:n-1  
   c(n-i,1:n-1)=c(n-i+1,n*(find(a(n-i+1,:)==1))-(n-2):n*(find(a(n-i+1,:)==1))) ; 
   c(n-i,n)='0'    ;               
   c(n-i,n+1:2*n-1)=c(n-i,1:n-1);  
   c(n-i,2*n)='1'      ;           
   for j=1:i-1  
      c(n-i,(j+1)*n+1:(j+2)*n)=c(n-i+1,n*(find(a(n-i+1,:)==j+1)-1)+1:n*find(a(n-i+1,:)==j+1));                                                                                                                             
   end  
end                            

 for i=1:n  
  h(i,1:n)=c(1,n*(find(a(1,:)==i)-1)+1:find(a(1,:)==i)*n)  ;
    ll(i)=length(find(abs(h(i,:))~=32))   ;                

 end
 
 %summary:
 
 l=sum(p.*ll)          ;  %计算平均码长
 hh=sum(p.*(-log2(p)));   %计算信源熵
 t=hh/l                 ; %计算编码效率
 
 output_args =floor(h/49);
%   output_args =(h);
  fuff_leng =ll;
 
 

end

