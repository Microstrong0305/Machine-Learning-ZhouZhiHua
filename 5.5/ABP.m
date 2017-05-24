clear

x = xlsread('E:\machine_learning\BP\watermelon3.0.xlsx', 'Sheet1', 'A1:Q8');
y = xlsread('E:\machine_learning\BP\watermelon3.0.xlsx', 'Sheet1', 'A9:Q9');
x=x';     %x进行转置 
y=y';     %y进行转置
%将y设置为0,1两类
y=y-1;
%获取输入参数的样本数与参数数
[m,d]=size(x);    %m是x矩阵的行数，表示总共有多少个训练集。d是矩阵的列数，表示训练集的输入。

OutputLayerNum=1;  %输出层神经元

v=rand(d,d+1);                      %输入层与隐层的权值,v是一个d行d+1列矩阵
w=rand(d+1,OutputLayerNum);         %隐层与输出层的权值,w是一个d+1行1列矩阵
gamma=rand(d+1);                    %隐层阈值,gamma是d+1行1列矩阵
theta=rand(OutputLayerNum);         %输出层阈值,theta是1行1列矩阵
py=zeros(m,OutputLayerNum);         %输出层输出
b=zeros(d+1);                       %隐层输出
g=zeros(OutputLayerNum);            %均方误差对w,gamma求导的参数
e=zeros(d+1);                       %均方误差对v,theta求导的参数

eta=1;                               %学习率

kn=0;        %迭代的次数
sn=0;        %同样的均方误差值累积次数
previous_E=0; %前一次迭代的累计误差
while(1)
    kn=kn+1;
    E=0;      %当前迭代的均方误差
    %计算全部样本输出层输出
    for i=1:m
      %计算隐层的输出
      for j=1:d+1
        alpha=0;
        for k=1:d
          alpha=alpha+v(k,j)*x(i,k);
        end
        b(i,j)=1/(1+exp(-alpha+gamma(j)));
       end
       %计算输出层输出
       for j=1:OutputLayerNum
         beta=0;
         for k=1:d+1
           beta=beta+w(k,j)*b(i,k);
          end
          py(i,j)=1/(1+exp(-beta+theta(j)));
         end
        end
       %用来存储累积误差对四个变量的下降方向
       delta_v=zeros(d,d+1);
       delta_w=zeros(d+1,OutputLayerNum);
       delta_gamma=zeros(d+1);
       delta_theta=zeros(OutputLayerNum);
       %计算累积误差
       for i=1:m
         for j=1:OutputLayerNum
           E=E+((y(i)-py(i,j))^2)/2;
          end
          %计算w、theta导数参数
          for j=1:OutputLayerNum
            g(j)=py(i,j)*(1-py(i,j))*(y(i)-py(i,j));
          end
          %计算v、gamma导数参数
          for j=1:d+1
            teh=0;
            for k=1:OutputLayerNum
              teh=teh+w(j,k)*g(k);
            end
              e(j)=teh*b(i,j)*(1-b(i,j));
          end
          %计算w、theta导数
          for j=1:OutputLayerNum
            delta_theta=delta_theta+(-1)*eta*g(j);
            for k=1:d+1
              delta_w(k,j)=delta_w(k,j)+eta*g(j)*b(i,k);
            end
          end
          %计算v、gamma导数
          for j=1:d+1
            gamma(j)= gamma(j)+(-1)*eta*e(j);
            for k=1:d
              delta_v(k,j)=delta_v(k,j)+eta*e(j)*x(i,k);
            end
           end
          end
          %更新参数
          v=v+delta_v;
          w=w+delta_w;
         gamma=gamma+delta_gamma;
         theta=theta+delta_theta;
         %迭代终止条件
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