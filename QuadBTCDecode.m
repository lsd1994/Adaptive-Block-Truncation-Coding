function QuadBTCDecode(I)
%load bitstream after encoding
input=fopen('bitstream.txt','r');
[m,n]=size(I);
decode=fgets(input);
code_length=length(decode);
fprintf('length of code: %d\n',code_length);
fprintf('bit per pixel: %.3f\n',code_length/(m*n));
fclose(input);

%each blocks decode from bitstream
img_recon=zeros(m,n);
global pos;pos=1;
for i=1:16:m
    for j=1:16:n
        img_recon(i:i+15,j:j+15)=QuadBTCRecon(decode,16,16);
    end
end

%decompression information
% I=imread('lena.png');
I=im2double(I)*255;
fprintf('psnr: %.3f\n',psnr(img_recon,I,255));

figure,
subplot(121),imshow(I,[]);
subplot(122),imshow(img_recon,[]);
impixelinfo;