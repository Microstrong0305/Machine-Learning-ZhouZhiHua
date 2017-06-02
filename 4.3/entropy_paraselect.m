%{
信息增益选择
    curset:当前样本集合
    pf：当前属性的编号
    pu：当前属性是连续还是离散的0-离散 1-连续
输出
    n：最优属性
    threshold:连续属性返回阀值
%}
function [n, threshold] = entropy_paraselect(curset,pf,pu)
global x y; 
    %通过样本编号与属性获取当前需要的样本
    curx = x(pf,curset);
    cury = y(curset);
    pn = size(pf);  %剩余属性数
    all = size(cury);   %当前样本总数
    max_ent = -100;     %为ent设初值，要最大值，所以设为一个很小的数
    minn=0;             %记录最优的属性编号
    threshold = 0;  
    for i=1:pn(2)
        if(pu(i) == 1)%连续性变量   %具体方法书上有
            con_max_ent =  -100;
            con_threshold = 0;
            xlist = sort(curx(i,:),2);
            %计算n-1个阀值
            for j=all(2):-1:2
               xlist(j) = (xlist(j)+xlist(j-1))/2;
            end
            %从n-1个阀值中选最优    (循环过程中ent先递减后递增 其实只要后面的ent比前面的大就可以停止循环)
            for j=2:all(2)
               cur_ent = 0; 
               %计算各类正负例数
               nums = zeros(2,2);
               for k=1:all(2)
                    nums((curx(i,k)>=xlist(j))+1,cury(k)) = nums((curx(i,k)>=xlist(j))+1,cury(k)) + 1;
               end
               %计算ent  连续属性只分两种情况
               for k=1:2
                   if(nums(k,1)+nums(k,2) > 0)
                p=nums(k,1)/(nums(k,1)+nums(k,2));
                cur_ent = cur_ent + (p*log2(p+0.00001)+(1-p)*log2(1-p+0.00001))*(nums(k,1)+nums(k,2))/all(2);
                   end
               end
               %记录该分类最优取值
               if(cur_ent>con_max_ent)
                   con_max_ent = cur_ent;
                   con_threshold = xlist(j);
               end
            end
            %如果该最优取值比当前总的最优还要优，记录
            if(con_max_ent > max_ent)
                max_ent=con_max_ent;
                minn = i;
                threshold = con_threshold;
            end
        else
            %离散型
            %除了分类数多了 其他一样
            cur_ent = 0; 
            set_data=unique(curx(i,:));
            setn=size(set_data);
            nums = zeros(10,2);
            for j=1:all(2)
               nums(curx(i,j),cury(j))=nums(curx(i,j),cury(j))+1;
            end
            for j=1:setn(2)
                if((nums(set_data(j),1)+nums(set_data(j),2))>0)
                 p=nums(set_data(j),1)/(nums(set_data(j),1)+nums(set_data(j),2));
                 cur_ent = cur_ent +(p*log2(p+0.00001)+(1-p)*log2(1-p+0.00001))*(nums(set_data(j),1)+nums(set_data(j),2))/all(2);
                end
            end
            if(cur_ent > max_ent)
                minn = i;
                max_ent = cur_ent;
            end
        end
    end
    n = minn;
    threshold = threshold * pu(n);

end