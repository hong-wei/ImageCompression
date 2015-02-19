%compression

% 1 read the data from the PGM file 
pgm_image_name='eg2014.pgm';
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

%test the InveTransform
% data_read_Trans_b= RowInveTransform(data_Trans_b,width,height);
% isequal(data_Trans_a,data_read_Trans_b)
% data_read_Trans_c= ColInveTransform(data_Trans_c,width,height);
% isequal(data_Trans_b,data_read_Trans_c)


% 3 Quantization

%3.1 allocation the data to letters
% The lab sheet :Fig. 2 shows a labelling of each regions importance 
% consfrom to the picture c  :data_Trans_c =<768*1024>.
% Actually,data_Trans_c_value = <768*1024> - <368:512>
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
% You should pick a predetermined distribution 
% and predetermined encoding tree for each of the regions d,e,f,g.

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
% [e_pro,e_huff_number] = CountProbilty(e_qtz_5);
% e_pro1= [e_pro(1:15),e_pro(17)];
% e_huff_number1=[e_huff_number(1:15),e_huff_number(17)];
% [e_huff_arr,e_huff_leng]=HuffmanArray(e_pro1(1:length(e_pro1)));
% e_qtz_huff_bits = HuffmanToBits(e_qtz_5,e_huff_arr,e_huff_number1,e_huff_leng);

[e_pro,e_huff_number] = CountProbilty(e_qtz_5);
% e_pro1= [e_pro(1:15),e_pro(17)];
% e_huff_number1=[e_huff_number(1:15),e_huff_number(17)];
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
f=fopen('eg2014.hongwei', 'w');
for i = 1:n
    fwrite(f,TotalBits_write(i), 'ubit1');
end
fclose(f);





