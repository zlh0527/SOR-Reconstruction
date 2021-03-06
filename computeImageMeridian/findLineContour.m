function contour_line = findLineContour(image)

%% load data
width = 1080;
height = 720;
load('../Data/f25_1080_720/25_1_inv.mat');

abcdef_High=abcdef_High/abcdef_High(6);
a=abcdef_High(1);
b=abcdef_High(2);
c=abcdef_High(3);
d=abcdef_High(4);
e=abcdef_High(5);
f=abcdef_High(6);

figure(1);
syms x;
syms y;
z1=a*x^2+b*x*y+c*y^2+d*x+e*y+f;
h1=ezplot(z1,[0,width,0,height]);
set(h1,'Color','r');
hold on

%% 找直线
RGB = imread(image) ;%Read the image
Highlight=RGB;
I=rgb2gray(RGB);     %transform the image to gray
[x,y]=size(I);       %get the size of the picture
BW=edge(I);          %get the edge of the picture


rho_max=floor(sqrt(x^2+y^2))+1; %由原图数组坐标算出ρ最大值，并取整数部分加1
%此值作为ρ，θ坐标系ρ最大值
accarray=zeros(rho_max,180); %定义ρ，θ坐标系的数组，初值为0。
%θ的最大值，180度

Theta=[0:pi/180:pi]; %定义θ数组，确定θ取值范围
for n=1:x,
    for m=1:y
        if BW(n,m)==1
            for k=1:180
            %将θ值代入hough变换方程，求ρ值
                rho=(m*cos(Theta(k)))+(n*sin(Theta(k)));
                %将ρ值与ρ最大值的和的一半作为ρ的坐标值（数组坐标），这样做是为了防止ρ值出现负数
                rho_int=round(rho/2+rho_max/2);
                %在ρθ坐标（数组）中标识点，即计数累加
                accarray(rho_int,k)=accarray(rho_int,k)+1;
            end
        end
    end
end


%=======利用hough变换提取直线======%
%寻找100个像素以上的直线在hough变换后形成的点
%寻找一个最长的直线上的点
K=3; %存储数组计数器
min_length = 100;
while (K>=3)
    K=1;
    min_length =min_length+1;
    for rho_n=1:rho_max %在hough变换后的数组中搜索
        for theta_m=1:180
            if accarray(rho_n,theta_m) >= min_length      %选择一条最长的
            %if (accarray(rho_n,theta_m) >= 40) && (accarray(rho_n,theta_m) <= 400) %选择长度范围在此之间的直线。
                %accarray(rho_n,theta_m)
                case_accarray_n(K)=rho_n; %存储搜索出的数组下标
                case_accarray_m(K)=theta_m;
                K=K+1;
            end
        end
    end
end

%=====把这些点构成的直线提取出来,输出图像数组为I_out===%
I_out=zeros(x,y);
I_jiao_class=zeros(x,y);

X=[];
Y=[];
count  =1;
for n=1:x,
    for m=1:y
         if BW(n,m)==1
             for k=1:180
              rho=(m*cos(Theta(k)))+(n*sin(Theta(k)));
              rho_int=round(rho/2+rho_max/2);             
                for a=1:K-1    
                    if rho_int==case_accarray_n(a)&k==case_accarray_m(a)%%%==gai==%%% k==case_accarray_m(a)&rho_int==case_accarray_n(a)
                    I_out(n,m)=BW(n,m); 
                    X(count)=n;
                    Y(count)=m;
                    count = count+1;
                        for p=0:5 %在原RGB图像上高亮
                         Highlight(n,m+p,1)=255;
                         Highlight(n,m+p,2)=0;
                         Highlight(n,m+p,3)=0;
                        end
                    I_jiao_class(n,m)=k;
                    end
                end
             end
         end
    end
end

%% 画圆锥的轮廓线
% Y = p(1)X + p(2)
p = polyfit(Y,X,1);
contour_line = [p(1), -1, p(2)]'/p(2);
save contour_line contour_line
figure(1);
b_con=-1*contour_line(3)/contour_line(2); 
k_con=-1*contour_line(1)/contour_line(2);
x=0:0.1:1080;
y = k_con*x+b_con;
plot(x,y,'b');
hold on

contour_points=[Y;X]';
save contour_points contour_points;
%plot(Y,X,'o');
set(gca,'ydir','reverse');
axis equal;
axis([0 1080 0 720]);
hold on


% figure(1);
% plot(Y,X,'o',X,polyval(p,X));
% set(gca,'ydir','reverse');
% axis equal;
% axis([0 y 0 x]);

figure(2),imshow(Highlight);
title('高亮图');
%imwrite(Highlight,'高亮图.jpg','jpg');









