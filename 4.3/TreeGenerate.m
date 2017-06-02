%{
    parent:父节点编号
    curset:当前的样本编号集合
    pf:当前的属性编号集合
    pu：属性是连续还是离散的 0-离散 1-连续
    pt：属性对应的分类数，连续属性用不着(可以设为0)
%}
function TreeGenerate(parent,curset,pf,pu,pt)
global x y xigua fenlei1 fenlei; 
global tree treeleaf treeres ptr;
       %新增一个节点，并记录它的父节点
       ptr=ptr+1;
       tree(ptr)=parent;
       cur = ptr;

       %递归返回情况1:当前所有样本属于同一类
       n = size(curset); 
       n = n(2);

       %计算当前y的取值分类及各有多少个  如果只有一类表示属于同一类
       cury=y(curset);  %通过当前样本编号从所有样本中选出当前样本
       y_data=unique(cury); %集合去重
       y_nums=histc(cury,y_data);   %统计各个取值各多少个

       if(y_nums(1)==n)
            treeres{1,ptr} = xigua{y_data};
            treeleaf(cur) = 1;
            return;
       end

       %递归返回情况2:
       %属性已经全部划分还有不同分类的样本，或者所有样本属性一致但是分类不同(这时就是有错误的样本)
       pfn=size(pf);    %记录当前属性个数

       tmp_para = x(pf,curset(1));
       f = 1;
       classy = y(curset(1));
       sum=zeros(1,2);
       for i=1:n
            if isequal(tmp_para , x(pf,curset(i)))
                t = (classy == y(curset(i)));
                sum(t) = sum(t)+1;
            else
                f=0;
                break;
            end
       end
       if(f == 1 || pfn(2) == 0) 
            treeres{1,cur} = xigua{(sum(2)>=sum(1))+1};
            treeleaf(cur) = 1;
            return;
       end

       %主递归
       %实现了4个最优属性选择方法,使用了相同的参数与输出:信息增益，增益率，基尼指数，对率回归
       %具体参数介绍间函数具体实现
       %因为是相同的参数与输出，直接该函数名就能换方法
       [k, threshold] = entropy_paraselect(curset,pf,pu);
       curx = x(pf,:);  %通过属性编号从样本总体中选取样本(已经分类的离散属性不再需要)
       p_num=pf(k);       %记录当前属性的具体编号
       treeres{1,cur} = fenlei1{p_num};%记录当前节点的分类属性

       %离散与连续属性分别处理
       if(pu(k))    %连续属性
           %连续属性只会分为两类 大于阀值一类 小于阀值一类 分类后继续递归
             num = [1 1];
             tmp_set = zeros(2,100);
             for i=1:n
                if(curx(k,curset(i))>=threshold)
                    tmp_set(1,num(1))=curset(i);
                    num(1) = num(1)+1;
                else
                    tmp_set(2,num(2))=curset(i);
                    num(2) = num(2)+1;
                end
             end
             for i=1:2
                    %由于用数组存编号，会有0存在，将样本分开后与当前的样本求交集  把0去掉
                    ttmp_set = intersect(tmp_set(i,:),curset);  

                    treeres{2,ptr+1} = fenlei{i,p_num};               %记录分类具体属性
                    treeres{3,ptr+1} = threshold;       %记录阀值
                    TreeGenerate(cur,ttmp_set,pf,pu,pt);
             end
       else
            %离散型分类要按每个取值分，就算某个取值下样本为0，也要标记为当前样本下最多的一个分类
            tpt=pt(k);  %该属性对应多少情况

            pf(:,k)=[]; %离散属性只分一次，用完就从集合中去掉
            pu(:,k)=[];
            pt(:,k)=[];
            %记录每种属性取值下对应的正反例各是多少
            num = ones(1,tpt);
            tmp_set = zeros(tpt,100);
            n=size(curset);
            for i=1:n(2)             
               tmp_set(curx(k,curset(i)),num(curx(k,curset(i))))=curset(i);
               num(curx(k,curset(i))) = num(curx(k,curset(i)))+1;
            end
            %然后按每种取值递归
            for i=1:tpt
                   ttmp_set = intersect(tmp_set(i,:),curset);
                   n = size(ttmp_set);
                   %如果该取值下没有样本，不进行递归，标记为当前样本下最多的一个分类
                   if(n(2)==0)
                       ptr=ptr+1;
                       tree(ptr)=cur;
                       treeres{1,ptr} = xigua{(y_nums(2)>y_nums(1))+1};
                       treeres{2,ptr} = fenlei{i,p_num};
                   else
                    treeres{2,ptr+1} = fenlei{i,p_num};    %记录分类具体属性
                    TreeGenerate(cur,ttmp_set,pf,pu,pt);
                   end
            end
       end

end