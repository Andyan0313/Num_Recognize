clear
clc
im1=imread('8.png'); %��ȡͼƬ 0-9��Ӧ����0-9��ͼƬ��������Ϳ���
x=rgb2gray(im1);%��ԭͼתΪ�Ҷ�ͼ
%imshow(im1);%��ʾԭͼ
%imshow(x);%��ʾ�Ҷ�ͼ

fid=fopen('Num_dec.txt','wt');%��Ҫ����10���Ƶ������ļ���Matalb������ȷʶ��
fid_hex=fopen('Num_hex.txt','wt');%��Ҫ����16���Ƶ������ļ���Modelsim������ȷʶ��
[row,col]=size(x);
for i=1:1:row
	for j=1:1:col
		if(j==col)
			if(x(i,j)>100)%�ж���ֵ�����Ҷ�ͼ���ж�ֵ��
				fprintf(fid,'%02d\n',255);
                fprintf(fid_hex,'%02x\n',255);
			else
				fprintf(fid,'%02d\n',0);
                fprintf(fid_hex,'%02x\n',0);
			end
		else
			if(x(i,j)>100)%�ж���ֵ�����Ҷ�ͼ���ж�ֵ?
				fprintf(fid,'%02d\t',255);
                fprintf(fid_hex,'%02x\t',255);
			else 
				fprintf(fid,'%02d\t',0);
                fprintf(fid_hex,'%02x\t',0);
			end
		end
	end
end

