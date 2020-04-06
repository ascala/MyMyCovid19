Tpre=readtable("Mobility_Adj_pre_LockDown.csv");
Tpost=readtable("Mobility_Adj_post_LockDown.csv");

Apre=table2array(Tpre(:,2:21));
Apost=table2array(Tpost(:,2:21));

A1pre=Apre./sum(Apre);
A2pre=Apre'./sum(Apre);

A1post=Apost./sum(Apost);
A2post=Apost'./sum(Apost);

A=A1pre-diag(diag(A1pre)); i=find(A>0);
[max(A(i)) min(A(i)) mean(A(i)) var(A(i))]*1e3

A=A1post-diag(diag(A1post)); i=find(A>0);
[max(A(i)) min(A(i)) mean(A(i)) var(A(i))]*1e3

A=A2pre-diag(diag(A2pre)); i=find(A>0);
[max(A(i)) min(A(i)) mean(A(i)) var(A(i))]*1e3

A=A2post-diag(diag(A2post)); i=find(A>0);
[max(A(i)) min(A(i)) mean(A(i)) var(A(i))]*1e3

B=zeros(20,20); B1=B; B2=B; 
for i=1:20
    for j=1:20
        
        if Apre(i,j)>0
               B(i,j)=Apost(i,j)/Apre(i,j);
        end
        if A1pre(i,j)>0
               B1(i,j)=A1post(i,j)/A1pre(i,j);
        end
        if A2pre(i,j)>0
               B2(i,j)=A2post(i,j)/A1pre(i,j);
        end
        
    end
end


