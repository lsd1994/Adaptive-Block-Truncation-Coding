I=imread('lena.pgm');
% I=imread('barbara.pgm');

prethre=30;
postthre=800;
QuadBTCEncode(I,prethre,postthre);
QuadBTCDecode(I);