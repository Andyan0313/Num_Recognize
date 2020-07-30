clear
clc
im1=imread('8.png'); %读取图片 0-9对应数字0-9的图片，改这里就可以
x=rgb2gray(im1);%将原图转为灰度图
%imshow(im1);%显示原图
%imshow(x);%显示灰度图

fid=fopen('Num_dec.txt','wt');%需要生成10进制的数据文件，Matalb才能正确识别
fid_hex=fopen('Num_hex.txt','wt');%需要生成16进制的数据文件，Modelsim才能正确识别
[row,col]=size(x);
for i=1:1:row
	for j=1:1:col
		if(j==col)
			if(x(i,j)>100)%判断阈值，将灰度图进行二值化
				fprintf(fid,'%02d\n',255);
                fprintf(fid_hex,'%02x\n',255);
			else
				fprintf(fid,'%02d\n',0);
                fprintf(fid_hex,'%02x\n',0);
			end
		else
			if(x(i,j)>100)%判断阈值，将灰度图进行二值?
				fprintf(fid,'%02d\t',255);
                fprintf(fid_hex,'%02x\t',255);
			else 
				fprintf(fid,'%02d\t',0);
                fprintf(fid_hex,'%02x\t',0);
			end
		end
	end
end

