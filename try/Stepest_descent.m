% Just clear
clc  ; clear all ; close all ;

% Specifiy some attributes
filter_size = 10000; 
mean_val_1 = 0;
variance_val_1 = 0.27;
mean_val_2 = 0;
variance_val_2 = 0.1;

%Generate Noise
v_1_normal = randn(10500 , 1);
v_1_normal = v_1_normal(501:end); 
v_2_normal = randn(10500 , 1);
v_2_normal = v_2_normal(501:end);

% Add mean and variance
v_1 = v_1_normal * sqrt(variance_val_1) ;
v_1 = v_1 - mean(v_1);
v_2 = v_2_normal * sqrt(variance_val_2) ;
v_2 = v_2 - mean(v_2);

% numerator and denomirator 
b_1 = 1 ;
a_1 = [1 0.8458];
b_2 = 1 ;
a_2 = [1 -0.9458];

% create Filter for d_n
d_n = filter( b_1 , a_1 , v_1 );

%create filter for u_n
u_n = v_2 - filter( b_2 , a_2 , d_n );

% Calculate W , j_min with Direct Method
n_order = 4 ;
P = cross_corr(u_n,d_n,n_order);
R = corr_mtx(u_n,n_order);
sigma = var(d_n);
W0 = R^(-1) * P;
J_min = sigma - dot((P.'), W0);

%%
%calculate with recursive iteration
W_init = zeros(n_order , 1);
itr = 100;
alpha_vec = [0.1 0.2 0.3 0.4 0.5];
J = zeros( length(alpha_vec) , itr);
W = zeros( n_order , length(alpha_vec) );
%%
figure;
hold on
color = {'red','magenta','cyan','yellow','blue'};
style = {'--','-.',':','--','-'};

for i = 1 : length(alpha_vec)   
    % get current alpha value
    alpha = alpha_vec(i);
    W(: , i) = W_init ;
    for j = 1 : itr 
    W(: , i) = W(: , i) + alpha * (P - R * W(: , i));
    J(i,j) = sigma - (W(: , i).' * P) - (P.' * W(: , i)) + ( W(: , i).' * R * W(: , i)) ;
    end
    plot(J(i , :),sprintf('%c',char(style(i))),'color',sprintf('%c',char(color(i))));
end
xlabel('Time, n')
ylabel('J(n)')
legend('Mu=0.1','Mu=0.2','Mu=0.3','Mu=0.4','Mu=0.5')
hold off

