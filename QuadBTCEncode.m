function QuadBTCEncode(I,prethre,postthre)
% I=imread('lena.pgm');
% I=imread('barbara.pgm');

%size imformation
[m,n]=size(I);%m n must be divided by 16

%encoding by quadtree decomposition
I=im2double(I)*255;
global output;
global sob_hor;sob_hor=[1 2 1;0 0 0;-1 -2 -1];
global sob_ver;sob_ver=[1 0 -1;2 0 -2;1 0 -1];
output=fopen('bitstream.txt','w+');
for i=1:16:m
    for j=1:16:n
        tmp=I(i:i+15,j:j+15);
        QuadBTCDecom(tmp,prethre,postthre,16,16);%16x16 block
    end
end
fclose(output);

%code length
% input=fopen('bitstream.txt','r');
% code=fgets(input);
% code_length=length(code);
% fclose(input);

%compression information
% fprintf('length of code: %d\n',code_length);
% fprintf('bit per pixel: %.3f\n',code_length/(m*n));