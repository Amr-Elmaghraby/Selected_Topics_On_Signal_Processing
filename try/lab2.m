%% Recordig
RecDuration = 1;
Rec = audiorecorder;
disp('Start Recording');
recordblocking(Rec,RecDuration);
disp('End of Recording');
spe = getaudiodata(Rec);
size = 120;
seg = floor(RecDuration*8000/size);
Sel_Seg = 10;
x = zeros(size,seg);
play(Rec);
for i=0:(seg-1)
    x(:,i+1)=spe(i*size+1:(i+1)*size);
end
plot(x(:,Sel_Seg));
%% Analysis Filter
[a, g] = lpc(x(:,Sel_Seg),10);
fir = filter(a,1,x(:,Sel_Seg));

%% Synthesize Filter
W_k = -a;
iir = filter(1,-W_k,fir);
figure;
plot(iir);
%%
sound(iir)










