I=imread('../Data/f25_1080_720/line.png');
figure(1)
imagesc(I);
Igray=rgb2gray(I);
bwimg = Igray < 200;
[width,height]=size(bwimg);
% figure(2)
% imagesc(bwimg);

x = [];
y = [];
t = 1;
for i=1:width
    for j=1:height
        if(bwimg(i,j) == 1)
            x(t) = i;
            y(t) = j;
            t=t+1;
        end
    end
end

p = polyfit(y,x,1);
%plot(y,x,'o',x,polyval(p,x));
l_contour = [p(1),-1,p(2)]';
l_contour = l_contour /l_contour(3);
figure(2);
plot(y,x,'*r');
hold on
b=-1/l_contour(2); 
k=-1*l_contour(1)/l_contour(2);
x=0:0.1:width;
y = k*x+b;
plot(x,y, 'b');
hold on

set(gca,'ydir','reverse');
axis equal;
axis([0 height 0 width]);

save l_contour l_contour