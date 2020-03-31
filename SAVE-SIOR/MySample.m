function [vq t1q t2q ] = MySample(v1,t1,v2,t2,N)

    v1m=min(v1); v1M=max(v1); 
    v2m=min(v2); v2M=max(v2);
    vm=max(v1m,v2m); vM=min(v1M,v2M);

    Dv=vM-vm; dv=Dv/N;
    vq=vm+dv:dv:vM-dv; 
    
    [v1, index] = unique(v1); t1 = t1(index);
    [v2, index] = unique(v2); t2 = t2(index);
    
    t1q = interp1(v1,t1,vq);
    t2q = interp1(v2,t2,vq);

end

