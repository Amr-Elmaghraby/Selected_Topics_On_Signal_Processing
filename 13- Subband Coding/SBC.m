%% Clear
clear; close all; clc
%% Read img data
dat = imread('gray3.jpg');
if size(dat, 3) == 3
    dat = rgb2gray(dat);
end
% reshape image size to be dividable to 2
block_size = 4; 
size1 = size(dat,1);
size2 = size(dat,2);
zero_tap1 = 0;
zero_tap2 = 0;
if mod(size1, block_size) ~= 0
    zero_tap1 = block_size - mod(size1, block_size);
end
if mod(size2, block_size) ~= 0
    zero_tap2 = block_size - mod(size2, block_size);
end
img = zeros(size1+zero_tap1, size2+zero_tap2);
img(1:size1, 1:size2) = dat;
img = uint8(img);

figure;
subplot(121);
%plot original image
imshow(img);
title("Original IMG");
%% Compression
% 8-taps smith barnwell LPF coeffecient 
H0 = [0.03489, -0.010983, -0.06286, 0.223907, 0.55686, 0.357976, -0.0239002, -0.0759409];
% HPF coeffecient
H1 = H0 .* -(-1).^(1:length(H0));
de = 8;
c = 1;
a = img;
for i = 1:de
    a = round(filter(H0, 1, a));
    % to compress columns and rows per turns
    if c == 1
        a = downsample(a.', 2).';
        c = ~c;
    else
        a = downsample(a, 2);
        c = ~c;
    end
end
% convert a to unsigned integer 0-255 "gray scale value" 
COM_img = uint8(a);
subplot(122);
%plot compressed image
imshow(COM_img);

%% DECOMPRESSION
K0=H0;
c=1;
b=a;
for i=1:de
    %Upsample and Interpolate compressed img
    if c==1
        b=round(resample(b.',2,1)).';
        c= ~c;
    else
        b=round(resample(b,2,1));
        c= ~c;
    end
    % Filtering
    b = round(filter(H0,1,b));
end
b= uint8(b);
figure;
subplot(121);
imshow(img);title("Original IMG");
subplot(122);
imshow(b);
title("IMG after Decompression")





