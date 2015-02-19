% % Decompression

% 1 read the bin file
f=fopen('eg2014.hongwei','r');
TotalBits_read=fread(f,'ubit1');
fclose(f);
%test:
% C = (TotalBits_read(1:n)==TotalBits_write);%比较是否相同
% Count = sum(C)%统计两个数组元素相同的个数
% n-Count
% isequal(TotalBits_read(1:n),TotalBits_write)

% 
% 2 variable length decoding
% for a region
a_read_1  = TotalBits_read(1:length(a_qtz_bits));
a_read_10 = reshape(a_read_1,10,length(a_qtz_10))';
a_read_dec= bi2de(a_read_10);
isequal(a_read_dec,a_qtz_10);% test

% for b region
b_start= length(a_qtz_bits)+1;
b_finish=length(a_qtz_bits)+length(b_qtz_bits);
b_read_1= TotalBits_read(b_start:b_finish);
b_read_8 = reshape(b_read_1,8,length(b_qtz_8))';
b_read_dec = BitsToqtz(b_read_8,8);
isequal(b_read_dec,b_qtz_8');% test

% for the c region
c_start  = b_finish+1;
c_finish = b_finish +length(c_qtz_bits);
c_read_1 = TotalBits_read(c_start:c_finish);
c_read_6 = reshape(c_read_1,6,length(c_qtz_6))';
c_read_dec = BitsToqtz(c_read_6,6);
isequal(c_read_dec,c_qtz_6');% test

% for the d region
d_start=c_finish+1;
d_finish=c_finish+length(d_qtz_huff_bits);
d_read_1 = TotalBits_read(d_start:d_finish)';
d_read_6 = BitsToHuffman(d_read_1,d_huff_number,d_huff_arr,d_huff_leng);
isequal(d_read_6,d_qtz_6);% test


% for the e region
e_start=d_finish+1;
e_finish=d_finish+length(e_qtz_huff_bits);
e_read_1 = TotalBits_read(e_start:e_finish)';
e_read_5 = BitsToHuffman(e_read_1,e_huff_number,e_huff_arr,e_huff_leng);
isequal(e_read_5,e_qtz_5);% test

% for the f region
f_start=e_finish+1;
f_finish= e_finish+length(f_qtz_huff_bits);
f_read_1 = TotalBits_read(f_start:f_finish)';
f_read_4 = BitsToHuffman(f_read_1,f_huff_number,f_huff_arr,f_huff_leng);
isequal(f_read_4,f_qtz_4);% test

% for g region write 196608*1 bits
g_start = f_finish+1;
g_finish= f_finish+length(g_qtz_bits);
g_read_1 = TotalBits_read(g_start:g_finish);
isequal(g_read_1,g_qtz_1);% test


% 
% 3 invert quantization  
% a  b c d e f g
% 10 8 6 6 5 4 1 
a_read_region  = DataInvQuanti(a_read_dec,16,96,128);  % 0--1024
b_read_region  = DataInvQuanti(b_read_dec,64,96,256);  % -127-- 127
c_read_region  = DataInvQuanti(c_read_dec,128,96,128); % -31--31
d_read_region  = DataInvQuanti(d_read_6,64,192,512);   % -31--31
e_read_region  = DataInvQuanti(e_read_5(1:49152),128,192,256); % -15--15
f_read_region  = DataInvQuanti(f_read_4,64,384,1024);  % -7--7
g_read_region  = DataInvQuanti(g_read_1,512,384,512);  % 0-- 1

% 
% %3.1 allocation the data to letters

% % 
data_read_Trans_c(385:768,513:1024)=g_read_region;
data_read_Trans_c(1:384,513:1024) =f_read_region(:,1:512);
data_read_Trans_c(385:768,1:512)  =f_read_region(:,513:1024);

data_read_Trans_e(193:384,257:512)= e_read_region;
data_read_Trans_e(1:192,257:512)=d_read_region(:,1:256);
data_read_Trans_e(193:384,1:256)=d_read_region(:,257:512);

data_read_Trans_g(1:96,1:128)  = a_read_region;
data_read_Trans_g(1:96,129:256)= b_read_region(:,1:128);
data_read_Trans_g(97:192,1:128)= b_read_region(:,129:256);
data_read_Trans_g(97:192,129:256) =c_read_region;


%4 Inverse Transform
width  = 1024; 
height = 768;
 
% g-->f
data_read_Trans_f = ColInveTransform(data_read_Trans_g,width/4,height/4);
% f-->e
data_read_Trans_e(1:192,1:256) = RowInveTransform(data_read_Trans_f,width/4,height/4);
% e-->d
data_read_Trans_d= ColInveTransform(data_read_Trans_e,width/2,height/2);
% d-->c
data_read_Trans_c(1:384,1:512)= RowInveTransform(data_read_Trans_d,width/2,height/2);
% % c-->b
data_read_Trans_b= ColInveTransform(data_read_Trans_c,width,height);
% % b-->a
data_read_Trans_a= RowInveTransform(data_read_Trans_b,width,height);
% % a--> a source to write the data 
data_read_Source =round(data_read_Trans_a);


% 5 write the data to the PGM file 
WritePgm( data_read_Source ,1);

