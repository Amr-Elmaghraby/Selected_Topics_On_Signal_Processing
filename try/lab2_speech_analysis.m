fs=8000;
t_period=1/fs;
time_s=2;
xrec=audiorecorder();
disp('start recording')
recordblocking(xrec,time_s)
disp('end recording')
 data=getaudiodata(xrec);
 n=(15e-3)/t_period;
 figure%(Name='Original speech')
 plot(data)
 sound(data,fs)
 %%
 u_n=data( length(data)/2 : length(data)/2 +n-1);
 figure%(Name='Part from orignial speech') 
plot(u_n)
%% encoding(analysis)
[a_k,pm]=lpc(u_n,10);
fm_n=filter(a_k,1,u_n);

[acs,lags] = xcorr(fm_n,'coeff');
figure%(Name='auto correlation of whitening noise')
plot(lags,acs)
grid
xlabel('Lags')
ylabel('Normalized Autocorrelation')
ylim([-0.1 1.1])

%% decoding(synthesis)
w_k=a_k(2:end).*-1;
restored_u=filter(1,[1 -w_k],fm_n);
figure%(Name='Restored part using fm_n')
plot(restored_u)

%%
sd=randn(1,length(fm_n));
sd=sqrt(pm)*sd;
sd=sd+ mean(fm_n)-mean(sd);


res=filter(1,[1 -w_k],sd);
figure%(Name='Restored part using random whitening noise')
plot(res)
%%
var(fm_n)
var(sd)

%%
mean(fm_n)
mean(sd)