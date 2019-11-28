function [ results ] = soundSamples( soundFile )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


fid = fopen(soundFile);
s = fscanf(fid,'%d\n',[1 inf]);
fclose(fid);

t = 1:length(s) ;
figure();
subplot(2,1,1);
%plot(t/8000,s); %AN EINAI SAMPLES H DIFF
plot(t/8000,s); %AN EINAI MEAN H STEP
title('Sound graph (Time Domain)');
xlabel('seconds');
ylabel('volts-->sound pressure');

%fourier
subplot(2,1,2);
Nfft = 1024;
f = linspace(0,8000, Nfft); 
%0 --> start frequency
%8000 --> end frequency (since I have 8000samples/sec in this app)
%Nfft --> the length of FFT (fast fourier transform)
G = abs(fft(s,Nfft));
plot(f(1:Nfft/2),G(1:Nfft/2));
title('Sound graph (Frequecy Domain)');
xlabel('frequencies (Hz)');
ylabel('Amplitude');


%  sample distribution
ssort = sort(s) ; %ta deigmata
counter = 1;
xprob = ones([2 2]);
xprob(1,1) = ssort(1);
i = 2;
while i<length(ssort)
    if ssort(i) == ssort(i-1)
        xprob(2,counter) = xprob(2,counter) + 1; 
    else
        counter = counter + 1;
        xprob(1,counter) = ssort(i);
        xprob(2,counter) = 1;
    end
    i = i + 1;
end

figure;

% subplot(2,1,1)
xprob(2,:) = xprob(2,:)/length(s);
bar(xprob(1,:), xprob(2,:));
title('Sample Distribution');
xlabel('Samples');
ylabel('Probability');
% na fainetai kalytera
NoParts = 200;
probSum = zeros([1 NoParts-1]);
maxpr = max(xprob(1,:));
minxpr = min(xprob(1,:));
SizeOfParts = (maxpr - minxpr)/NoParts ;
counter = 1;
for i=1 : NoParts
   %starting = i*SizeOfParts;
   ending = minxpr + (i+1)*SizeOfParts;
   while counter<length(xprob(2,:))
       if xprob(1,counter) < ending
           probSum(i) = probSum(i) + xprob(2,counter);
       else
           break;
       end
       counter = counter + 1;
   end
end
figure;
bar(1:(NoParts-1), probSum);
title('Sample Distribution');
xlabel('Samples');
ylabel('Probability');





results = s;
end

