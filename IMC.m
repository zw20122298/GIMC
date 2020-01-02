function [ XX ] = IMC(X)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

%% construct incomplete multi-view data
num_views=size(X,2);
n=size(X{1,1},2);
k=round(0.1*n); %missing rate
for v=1:num_views
    for sample=1:k
        j=randperm(n,1);
        if ~isnan(X{1,v}(:,j))
            X{1,v}(:,j)=nan;
        else
            j=randperm(n,1);
        end
    end
end

%% indicated matrix (M)
M=zeros(num_views,n);
for v=1:num_views
    for i=1:n
        if isnan(X{1,v}(:,i))
            M(v,i)=0;
        else
            M(v,i)=1;
        end
    end
end

%% weight matrix (W)
MM=(n-sum(M,2))/n;
W=cell(1,num_views);

for v=1:num_views
    W{1,v}=zeros(n,1);
end

for v=1:num_views
    for i=1:n
        if isnan(X{1,v}(:,i))
            W{1,v}(i)=MM(v);
        else
            W{1,v}(i)=1;
        end
    end
    W{1,v}=diag(W{1,v});
end
           
%% fill missing samples
s=cell(1,num_views);
aver=cell(1,num_views);
for v=1:num_views
    m=size(X{1,v},1);
    s{1,v}=zeros(m,1);
    for i=1:n
        if ~isnan(X{1,v}(:,i))
            s{1,v}=s{1,v}+X{1,v}(:,i);
        end
    end
    aver{1,v}=s{1,v}/n;
end

for v=1:num_views
    for i=1:n
        if isnan(X{1,v}(:,i))
            X{1,v}(:,i)=aver{1,v};
        end
    end
end

XX=cell(1,num_views);
for v=1:num_views
    X{1,v}=X{1,v}';
    XX{1,v}=W{1,v}*X{1,v};
    XX{1,v}=XX{1,v}';
end

end

