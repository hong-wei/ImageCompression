%compression

% 1 read the data from the PGM file 
pgm_image_name='myStar.pgm';
data_Source =ReadPgm(pgm_image_name);


%2 Transform
width  = 1024; % 1024/16 = 64
height = 768;
% a-->a
data_Trans_a =data_Source;
% a-->b
data_Trans_b= RowTransform(data_Trans_a,width,height);
% b-->c
data_Trans_c= ColTransform(data_Trans_b,width,height);
% c-->d
data_Trans_d= RowTransform(data_Trans_c,width/2,height/2);
% d-->e
data_Trans_e= ColTransform(data_Trans_d,width/2,height/2);
% e-->f
data_Trans_f= RowTransform(data_Trans_e,width/4,height/4);
% f-->g
data_Trans_g= ColTransform(data_Trans_f,width/4,height/4);

% 3 Quantization

%3.1 allocation the data to letters
g_region  = data_Trans_c(385:768,513:1024);
f1_region = data_Trans_c(1:384,513:1024);
f2_region = data_Trans_c(385:768,1:512);
f_region  = [f1_region,f2_region];

% consfrom to the picture e      :data_Trans_e =<384*512>.
% Actually,data_Trans_e_value = <384*512> - <192:256>
e_region   = data_Trans_e(193:384,257:512);
d1_region  = data_Trans_e(1:192,257:512);
d2_region  = data_Trans_e(193:384,1:256);
d_region   = [d1_region,d2_region];

% consfrom to the pitcure g: data_Trans_g = <192* 256>. 
a_region  = data_Trans_g(1:96,1:128);
b1_region = data_Trans_g(1:96,129:256);
b2_region = data_Trans_g(97:192,1:128);
b_region  = [b1_region,b2_region];
c_region  = data_Trans_g(97:192,129:256);


%3.2 quantization  as letters bits
% a  b c d e f g
% 10 8 6 6 5 4 1 
a_qtz_10 = DataQuanti(a_region,16);  % 0--1024
b_qtz_8  = DataQuanti(b_region,64);  % -127-- 127
c_qtz_6  = DataQuanti(c_region,128); % -31--31
d_qtz_6  = DataQuanti(d_region,64);  % -31--31
e_qtz_5  = DataQuanti(e_region,128); % -15--15
f_qtz_4  = DataQuanti(f_region,64);  % -7--7
g_qtz_1  = DataQuanti(g_region,512); % 0-- 1



% 4 Variable Length Coding
%for the a region
a_qtz_bits = qtzToBits(a_qtz_10,10);

% for the b region
b_qtz_bits = qtzToBits(b_qtz_8,8);

% for the c region
c_qtz_bits = qtzToBits(c_qtz_6,6); 

% for the d region
[d_pro,d_huff_number] = CountProbilty(d_qtz_6);
[d_huff_arr,d_huff_leng]=HuffmanArray(d_pro(1:length(d_huff_number)));
d_qtz_huff_bits = HuffmanToBits(d_qtz_6,d_huff_arr,d_huff_number,d_huff_leng );


%for the e region

[e_pro,e_huff_number] = CountProbilty(e_qtz_5);
[e_huff_arr,e_huff_leng]=HuffmanArray(e_pro(1:length(e_huff_number)));
e_qtz_huff_bits = HuffmanToBits(e_qtz_5,e_huff_arr,e_huff_number,e_huff_leng);



%fot the f region
[f_pro,f_huff_number] = CountProbilty(f_qtz_4);
[f_huff_arr,f_huff_leng]=HuffmanArray(f_pro(1:length(f_huff_number)));
f_qtz_huff_bits = HuffmanToBits(f_qtz_4,f_huff_arr,f_huff_number,f_huff_leng );


% for the g region
% only one bit ,store to the file drectly
g_qtz_bits =g_qtz_1';


% 5 save the file and exit
TotalBits = [a_qtz_bits,b_qtz_bits,c_qtz_bits,d_qtz_huff_bits,e_qtz_huff_bits,f_qtz_huff_bits,g_qtz_bits];

n=length(TotalBits);

TotalBits_write=TotalBits(1:n)';
f=fopen('myStar.hongwei', 'w');
for i = 1:n
    fwrite(f,TotalBits_write(i), 'ubit1');
end
fclose(f);






% % Decompression

% 1 read the bin file
f=fopen('myStar.hongwei','r');
TotalBits_read=fread(f,'ubit1');
fclose(f);

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
WritePgm1( data_read_Source ,1);

