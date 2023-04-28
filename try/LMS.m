%% LMS
 outer_itr=100;
 inner_itr=500;
 alpha_vec=[0.01 0.05 0.1];
 w=zeros(length(alpha_vec),inner_itr,outer_itr);
 error=zeros(length(alpha_vec),inner_itr,outer_itr);

 for k=1:100
    v_n=sqrt(0.02)*randn(10500,1);
    v_n=v_n(501:end);
    a_1=[1 -0.99];
    %generte u_n
    u_n=filter(1,a_1,v_n);

    %M_taps=1;
    
    stability_bound= 2/(1*var(u_n));
        
    for i=1:length(alpha_vec)
        
        for j=1:inner_itr-1
            error(i,j,k)=u_n(j)-w(i,j,k).*u_n(j+1);           
            w(i,j+1,k)=w(i,j,k)+alpha_vec(i)*u_n(j+1)*error(i,j,k);
        end

    end
 end
%% Averaging
w_avr=zeros(length(alpha_vec),inner_itr);
e_avr=zeros(length(alpha_vec),inner_itr);
 for i=1:100
    ww = w(:,:,i);
    ee =error(:,:,i);
    w_avr = ww +w_avr;
    e_avr = ee +e_avr;
 end
 w_avr = w_avr ./ outer_itr ;
 e_avr = e_avr ./ outer_itr;
 figure;
 plot(w_avr(1,:));
 figure;
 plot(e_avr(1,:));
 