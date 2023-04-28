
function [ R ] = corr_mtx(u_n ,n_order)
r =zeros(n_order,1);
for i=0:(n_order-1)
    sum =0;
    for j =1: (length(u_n)-i)
    sum = sum + u_n(j)*u_n(j+i);   
    end
    r(i+1)=sum/(length(u_n)-i);  
end
R_size = length(r);
R=zeros(R_size);
for i =1:R_size
    for j=1:R_size
        col=j+i-1;
        if col >R_size
            continue
        end
       R(i,col)=r(j);
       R(col,i)=r(j);
    end
end
end

