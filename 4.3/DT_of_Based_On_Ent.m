%{
    x:样本属性  连续变量直接用数值,离散变量用1，2，3区别
    y:样本分类值  1-好 2-不好
    tree:生成的树形结构，用数组表示 按先根遍历编号 值为父节点编号 1为根节点
    treeleaf:标记是否为叶子节点
    treeres:每组3个变量
            1:如果是叶子节点则记录分类 如果是非叶节点记录当前节点的分类属性
            2:离散属性直接记录父节点分类的具体属性 连续属性1-小于 2-大于
            3:如果是连续属性，记录阀值，离散属性为0
    ptr:节点数目累加变量
%}
global x y fenlei1 fenlei xigua; 
global tree treeleaf treeres ptr;

x = xlsread('E:\machine_learning\BP\Decision Tree\watermelon3.0.xlsx', 'Sheet1', 'A1:Q8');
y = xlsread('E:\machine_learning\BP\Decision Tree\watermelon3.0.xlsx', 'Sheet1', 'A9:Q9');

%西瓜属性的中文标识
fenlei1={'色泽',  '根蒂',   '敲声',   '纹理',   '脐部'    ,'触感','密度','含糖率'};
fenlei={
 '青绿','蜷缩', '浊响',   '清晰',   '凹陷',   '硬滑','小于','小于';
'乌黑',   '稍蜷',   '沉闷',   '稍糊',   '稍凹',   '软粘','大于','大于';
'浅白',   '硬挺',   '清脆',   '模糊',   '平坦',   '无','无','无';
};
xigua = {'好瓜','坏瓜'};

[m,n]=size(y);
%为set集合提前分配空间 集合中存放所有样本的编号
for i=n:-1:1
    set(i) = i;
end

%为tree相关变量提前分配空间
tree=zeros(1,100);
treeleaf=zeros(1,100);
treeres=cell(3,100);
ptr = 0;
%{
手动设置的变量:修改输入数据时要收到修改
    pf：属性的编号，按顺序编号
    pu：属性是连续还是离散的0-离散 1-连续
    pt：属性对应的分类数，连续属性用不着(可以设为0)
%}
pf=[1 2 3 4 5 6 7 8];
pu=[0 0 0 0 0 0 1 1];
pt=[3 3 3 3 3 2 0 0];

%主递归程序
TreeGenerate(0,set,pf,pu,pt);

%绘制树形 仅有树形
treeplot(tree(1:ptr));