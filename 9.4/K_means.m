x = xlsread('E:\machine_learning\Machine-Learning-ZhouZhiHua\9.4\watermelon4.0.xlsx', 'Sheet1', 'A1:B30');
[m,n]=size(x);    %m表示行、n表示列
k=4;%设置k值,即要聚类的个数
u=x(randperm(m,k),:);  %随机均值
while 1
  c=zeros(k,30);    %将各类集合清空
  nums=zeros(k,1);  
  %对所有样本遍历，选择最近的集合
  for i=1:m
    mind=100000;   %存放最短的距离
    minl=0;        %x的族标记
    for j=1:k 
      d=norm(x(i,:)-u(j,:));   %计算样本x到各均值向量的距离
      if(d<mind)
      mind=d;
      minl=j;
      end
     end
     nums(minl)=nums(minl)+1;   %相应族的聚类个数
     c(minl,nums(minl))=i;      %
   end
   %计算两次均值差异，并更新均值
   up=zeros(k,2);
   for i=1:k
     for j=1:nums(i)
       up(i,:)=up(i,:)+x(c(i,j),:);
      end
      up(i,:)=up(i,:)/nums(i);
   end
   %迭代结束的条件
   delta_u=norm(up-u);
   if(delta_u<0.001)
      break;
    else
       u=up;
   end
end

%各类使用不同的符号绘制
ch='o*+.>';

for i=1:k
  %绘制类中的点
  plot(x(c(i,1:nums(i)),1),x(c(i,1:nums(i)),2),ch(i));
  hold on;
  tc=x(c(i,1:nums(i)),:);       %同族样本所有数据
  %计算类凸包并画线
  chl=convhull(tc(:,1),tc(:,2));   %Octave中convhull(x,y)必须有两个参数
  %在Matlab中使用
  %chl=convhull(tc);
  line(tc(chl,1),tc(chl,2))
  hold on;
end

xlabel('密度');
ylabel('含糖率');
title('K-means'); 
      
     