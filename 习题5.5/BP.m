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
    for i=1:m
      %计算隐层输出
      for j=1:d+1
        alpha=0;   %当前一个隐层节点神经元的输入
        for k=1:d
          alpha=alpha+v(k,j)*x(i,k);
         end
         b(j)=1/(1+exp(alpha-gamma(j)));  %计算某个隐层节点的输出
       end
       %计算输出层输出
       for j=1:OutputLayerNum
         beta=0;
         for k=1:d+1
           beta=beta+w(k,j)*b(k);
         end
         py(i,j)=1/(1+exp(beta-theta));
        end
        %计算当前一个训练数据的均方误差
        for j=1:OutputLayerNum
          E=E+((py(i,j)-y(i))^2)/2;
        end
        %计算w,beta导数参数
        for j=1:OutputLayerNum
          g(j)=py(i,j)*(1-py(i,j))*(y(i)-py(i,j));
        end
        %计算v,gamma导数参数
        for j=1:d+1
          teh=0;
          for k=1:OutputLayerNum
            teh=teh+w(j,k)*g(k);
          end
          e(j)=teh*b(j)*(1-b(j));
         end
         %更新v,gamma
         for j=1:d+1
           gamma(j)=gamma(j)+(-eta)*e(j);
           for k=1:d
             v(k,j)=v(k,j)+eta*e(j)*x(i,k);
            end
           end
          %更新w,theta
          for j=1:OutputLayerNum
            theta(j)=theta(j)+(-eta)*g(j);
            for k=1:d+1
              w(k,j)=w(k,j)+eta*g(j)*b(k);
             end
           end
         end
         %迭代终止判断
         if(abs(previous_E-E)<0.0001)
            sn=sn+1;
            if(sn==100)
               break;
             end
          else
             previous_E=E;
             sn=0;
         end
 end
          
          
        
          
         
           
          
      