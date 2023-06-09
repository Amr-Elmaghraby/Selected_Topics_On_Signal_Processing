clear , clc, close all;
image_name = 'gray.jpg';
delta = 0.0001;

% ****************************************************************************************
%Implementation is based on the document 'math.osu.edu/~husen/teaching/572/image_comp.pdf'
% ****************************************************************************************

close all;
disp(delta)
% Check number of inputs.


if (delta>1 || delta<0)
    error('harr_wt: Delta must be a value between 0 and 1');
end


%H1, H2, H3 are the transformation matrices for Haar wavelet Transform
H1=[0.5 0 0 0 0.5 0 0 0;0.5 0 0 0 -0.5 0 0 0;0 0.5 0 0 0 0.5 0 0 ;0 0.5 0 0 0 -0.5 0 0 ;0 0 0.5 0 0 0 0.5 0;0 0 0.5 0 0 0 -0.5 0;0 0 0 0.5 0 0 0 0.5;0 0 0 0.5 0 0 0 -0.5;];
H2=[0.5 0 0.5 0 0 0 0 0;0.5 0 -0.5 0 0 0 0 0;0 0.5 0 0.5 0 0 0 0;0 0.5 0 -0.5 0 0 0 0;0 0 0 0 1 0 0 0;0 0 0 0 0 1 0 0;0 0 0 0 0 0 1 0;0 0 0 0 0 0 0 1;];
H3=[0.5 0.5 0 0 0 0 0 0;0.5 -0.5 0 0 0 0 0 0;0 0 1 0 0 0 0 0;0 0 0 1 0 0 0 0;0 0 0 0 1 0 0 0;0 0 0 0 0 1 0 0;0 0 0 0 0 0 1 0;0 0 0 0 0 0 0 1;];


%Normalize each column of H1,H2,H3 to a length 1(This results in orthonormal columns of each matrix)
H1o = (H1.*(2^0.5));
H2o = (H2.*(2^0.5));
H3o = (H3.*(2^0.5));

Ho=normc(H1o*H2o*H3o); %Resultant transformation matrix
H = H1*H2*H3;
x=double(imread(image_name));

yo = zeros(size(x));
y = zeros(size(x));
[r,c]=size(x);
%Above 8x8 transformation matrix(H) is multiplied by each 8x8 block in the image

for i=0:8:r-8
    for j=0:8:c-8
        p=i+1;
        q=j+1;
        yo(p:p+7,q:q+7)=(Ho')*x(p:p+7,q:q+7)*Ho;
        y(p:p+7,q:q+7)=(H')*x(p:p+7,q:q+7)*H;
    end
end
n1= nnz(y); 
compression_ratio =50;
n2 = n1 / compression_ratio;
[y_sorted, idx ] = sort(abs(reshape(y, [r*c, 1])), 'ascend');
index =(r * c) - n2;
thresh = y_sorted(round(index+1));
for t=1:r
    for l=1:c
        if abs(y(t,l)) <= thresh
            y(t,l) = 0.0;
            % counter = counter + 1;
        end
    end
end
n2 = nnz(y);
figure;
imshow(x/255);


                         % Number of non-zero elements in 'y'

zo=yo;
m=max(max(yo));
yo=yo/m;
yo(abs(yo)<delta)=0;                  % Values within +delta and -delta in 'y' are replaced by zeros(This is the command that result in compression)
yo=yo*m;
                 % Values within +delta and -delta in 'y' are replaced by zeros(This is the command that result in compression)

 % Values within +delta and -delta in 'y' are replaced by zeros(This is the command that result in compression)

z=y;
y=y/m;
y(abs(y)<delta)=0;                  % Values within +delta and -delta in 'y' are replaced by zeros(This is the command that result in compression)
y=y*m;
                % Values within +delta and -delta in 'y' are replaced by zeros(This is the command that result in compression)



%Inverse DWT of the image

for i=0:8:r-8
    for j=0:8:c-8
        p=i+1;
        q=j+1;
        zo(p:p+7,q:q+7)=Ho*yo(p:p+7,q:q+7)*Ho';
        z(p:p+7,q:q+7)=inv(H')*y(p:p+7,q:q+7)*inv(H);
    end
end


figure;
subplot(121);
imshow(x/255);% Show the compressed image
title("original image");0222
subplot(122)
imshow(z/255);
title("compressed image");
imwrite(x/255,'orginal.tif');           %Check the size difference of the two images to see the compression
imwrite(z/255,'compressed.tif');

% Below value is a measure of compression ratio, not the exact ratio