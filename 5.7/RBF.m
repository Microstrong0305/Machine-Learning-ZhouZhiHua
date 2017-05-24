clear
x=[0 0;0 1; 1 0;1 1];
y=[0;1;1;0];

hideNum=10;               %隐层神经元数目，要求必须大于输入层个数
rho=rand(4,hideNum);       %径向基函数的值
py=rand(4,1);             %输出值
w=rand(1,hideNum);        %隐层第i个神经元与输出神经元的权值
beta=rand(1,hideNum);     %样本与第i个神经元的中心的距离的缩放系数
eta=0.5;                    %学习率

c=rand(hideNum,2);     %隐层第i个神经元的中心

kn=0;                 %累计迭代的次数
sn=0;                 %同样的累积误差值累积次数
previous_E=0;          %前一次迭代的累积误差

while(1)
  kn=kn+1;
  E=0;
  %计算每个样本的径向基函数值
  for i=1:4
    for j=1:hideNum
      p(i,j)=exp(-beta(j)*(x(i,:)-c(j,:))*(x(i,:)-c(j,:))');
     end
     py(i)=w*p(i,:)'; 
   end
   %计算累积误差
   for i=1:4
     E=E+((py(i)-y(i))^2);    %计算均方误差
   end
     E=E/2;    %累积误差
   
   %更新w、beta
   delta_w=zeros(1,hideNum);
   delta_beta=zeros(1,hideNum);
   for i=1:4
     for j=1:hideNum
       delta_w(j)=delta_w(j)+(py(i)-y(i))*p(i,j);
       delta_beta(j)= delta_beta(j)-(py(i)-y(i))*w(j)*(x(i,:)-c(j,:))*(x(i,:)-c(j,:))'*p(i,j);
      end
     end
     
    %更新w、beta
    w=w-eta*delta_w/4;
    beta=beta-eta*delta_beta/4;
    
    %迭代终止的条件
    if(abs(previous_E-E)<0.0001)
       sn=sn+1;
       if(sn==50)
         break;
        end
     else
       previous_E=E;
       sn=0;
      end
      
 end
       
      
      