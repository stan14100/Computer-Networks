function [ result ] = echoPackets( echoFile)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%read files
fid = fopen(echoFile);
ec = fscanf(fid, 'Packet No%d:%dms\n', [2 Inf]);
fclose(fid);

%remove timed out packets
iNew = 1;
for k=1: length(ec(2,:))
   if ec(2,k) ~= 0
        ecNew(1,iNew) = iNew;
        ecNew(2,iNew) = ec(2,k);
        iNew = iNew + 1;
   end
end
ec = ecNew ;  
%sxediagrammata
figProb = figure('Name', [echoFile  '%s Probability functions ' ] );
figMain = figure('Name',echoFile);
subplot(4,1,1);
bar(ec(1,:),ec(2,:));
hold on;
mean_value_Echo = sum(ec(:,2))/length(ec(:,2))
diaspora = var(ec(:,2))
typikh_apoklish = std(ec(:,2))
plot([0,length(ec(2,:))],[mean_value_Echo mean_value_Echo],'r','Linewidth',2);
hold off;
legend('Response Time','Mean value');
title('Echo');
xlabel('Packet Number');
ylabel('Response Time (millisec)');

figure(figProb);
subplot(2,1,1);
maxec = max(ec(2,:));

yprob = zeros( [1 maxec] );
for i=1 : length(ec(2,:))
   yprob(ec(2,i)) = yprob(ec(2,i)) + 1; 
end
yprob = yprob / length(ec(2,:)) ;
bar( ( 1:maxec ) , yprob );
title('Echo Probability');
xlabel('Response Time');
ylabel('Probability');

%twn 20 prin kai 20 meta
sumindex = 40;
maxec = max(ec(2,:));
sumprob = zeros([ 1 (floor(maxec/(2*sumindex)))]) ;
xsumprob = zeros([ 1 (floor(maxec/(2*sumindex)))]) ;
subplot(2,1,2);
count = 1;
i = 1;
while i < maxec
    tempi = i - 1;
    xsumprob(count) = i ;
    sumprob(count) = yprob(i) ;
   while(tempi > 1 && i-tempi < sumindex) 
      sumprob(count) = sumprob(count) + yprob(tempi) ;
      tempi = tempi - 1;
   end
   tempi = i + 1;
   while(tempi <= length(yprob) && tempi-i <= sumindex) 
      sumprob(count) = sumprob(count) + yprob(tempi) ;
      tempi = tempi + 1;
   end
   count = count + 1;
   i = i+(2*sumindex);
end
bar( xsumprob , sumprob );
xlabel('Response Time Value');
ylabel('Probability');

p = polyfit(xsumprob, sumprob, 7 );
fapprox = polyval(p, xsumprob);
hold on 
plot(xsumprob, fapprox,'r');

legend('real data average','approximation')

figure(figMain);
%moving by 1 sec throughput
%THE LENGTH of the answer is 32 bytes
subplot(4,1,2);

%8 seconds
sumtemp = 0;
ads = zeros([1 10]); %average download speed
packetcounter = 1 ;
sumDeyteroleptoy = 0;
prisonDeyteroleptou = 0;
el = 1;
ads(el) = 32*8*1000/ec(2,1) ;
%prison = 0;
limit = 8000;
for ( i = 1 : length(ec(1,:)) )
    sumDeyteroleptoy = sumDeyteroleptoy + ec(2,i) + prisonDeyteroleptou;
    prisonDeyteroleptou = 0;
    if sumDeyteroleptoy < 1000
        continue;
    end
    prisonDeyteroleptou = sumDeyteroleptoy - 1000 ;
    while (sumtemp < limit && ( (i-packetcounter) > 0 ) )
        sumtemp = sumtemp + ec(2,i-packetcounter);
        packetcounter = packetcounter + 1;
    end
   %perasan 8 deyterolepta
%    if sumtemp > limit
%       prison = sumtemp - limit; 
%       el = el + 1;
%       ads(el) = (packetcounter-1)*32*8*1000/limit ;
%    else
      el = el + 1;
      ads(el) = (packetcounter-1)*32*8*1000/sumtemp ;
  % end
   sumtemp = 0;
   packetcounter = 1 ;
   sumDeyteroleptoy = 0;
end

plot((1:el),ads);
title('Download Rate Probability (bits per second)');
xlabel('seconds');
ylabel('(bps)');

figure('Name', [echoFile  '%s Probability functions (average speed from 8 seconds) ' ] );
subplot(2,1,1);


adsort = sort(ads) ; %ta deigmata

counter = 1;
xprob = ones([2 2]);
xprob(1,1) = adsort(1);
i = 2;
while i<length(adsort)
    if adsort(i) == adsort(i-1)
        xprob(2,counter) = xprob(2,counter) + 1; 
    else
        counter = counter + 1;
        xprob(1,counter) = adsort(i);
        xprob(2,counter) = 1;
    end
    i = i + 1;
end

xprob(2,:) = xprob(2,:)/length(adsort);
bar(xprob(1,:), xprob(2,:));
title('Download Rate Probability');
xlabel('(bps)');
ylabel('Probability');
%na fainetai kalytera
NoParts = 10;
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

subplot(2,1,2);
bar(1:(NoParts-1), probSum);
xlabel('(bps)');
ylabel('Probability');

set(gca, 'XTickLabel',{ [num2str(minxpr,3) '-' num2str(minxpr+1*SizeOfParts,3)], [num2str(minxpr+1*SizeOfParts,3) '-' num2str(minxpr+2*SizeOfParts,3)] ...
    ,[num2str(minxpr+2*SizeOfParts,3) '-' num2str(minxpr+3*SizeOfParts,3)], [num2str(minxpr+3*SizeOfParts,3) '-' num2str(minxpr+4*SizeOfParts,3)] ...
    ,[num2str(minxpr+4*SizeOfParts,3) '-' num2str(minxpr+5*SizeOfParts,3)], [num2str(minxpr+5*SizeOfParts,3) '-' num2str(minxpr+6*SizeOfParts,3)] ...
    ,[num2str(minxpr+6*SizeOfParts,3) '-' num2str(minxpr+7*SizeOfParts,3)], [num2str(minxpr+7*SizeOfParts,3) '-' num2str(minxpr+8*SizeOfParts,3)] ...
    ,[num2str(minxpr+8*SizeOfParts,3) '-' num2str(minxpr+9*SizeOfParts,3)] });

p = polyfit(1:(NoParts-1), probSum, 4 );
fapprox = polyval(p, 1:(NoParts-1));
hold on 
plot(1:(NoParts-1), fapprox,'r');
legend('real data average','approximation')


figure(figMain);

subplot(4,1,3);
%16 seconds
sumtemp = 0;
ads = zeros([1 10]); %average download speed
packetcounter = 1 ;
sumDeyteroleptoy = 0;
prisonDeyteroleptou = 0;
el = 1;
ads(el) = 32*8*1000/ec(2,1) ;
%prison = 0;
limit = 16000;
for ( i = 1 : length(ec(1,:)) )
    sumDeyteroleptoy = sumDeyteroleptoy + ec(2,i) + prisonDeyteroleptou;
    prisonDeyteroleptou = 0;
    if sumDeyteroleptoy < 1000
        continue;
    end
    prisonDeyteroleptou = sumDeyteroleptoy - 1000 ;
    while (sumtemp < limit && ( (i-packetcounter) > 0 ) )
        sumtemp = sumtemp + ec(2,i-packetcounter);
        packetcounter = packetcounter + 1;
    end
   %perasan 8 deyterolepta
%    if sumtemp > limit
%       prison = sumtemp - limit; 
%       el = el + 1;
%       ads(el) = (packetcounter-1)*32*8*1000/limit ;
%    else
      el = el + 1;
      ads(el) = (packetcounter-1)*32*8*1000/sumtemp ;
  % end
   sumtemp = 0;
   packetcounter = 1 ;
   sumDeyteroleptoy = 0;
end

plot((1:el),ads);
xlabel('seconds');
ylabel('(bps)');

figure('Name', [echoFile  '%s Probability functions (average speed from 16 seconds) ' ] );
subplot(2,1,1);


adsort = sort(ads) ; %ta deigmata

counter = 1;
xprob = ones([2 2]);
xprob(1,1) = adsort(1);
i = 2;
while i<length(adsort)
    if adsort(i) == adsort(i-1)
        xprob(2,counter) = xprob(2,counter) + 1; 
    else
        counter = counter + 1;
        xprob(1,counter) = adsort(i);
        xprob(2,counter) = 1;
    end
    i = i + 1;
end

xprob(2,:) = xprob(2,:)/length(adsort);
bar(xprob(1,:), xprob(2,:));
title('Download Rate Probability');
xlabel('(bps)');
ylabel('Probability');
%na fainetai kalytera
NoParts = 10;
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

subplot(2,1,2);
bar(1:(NoParts-1), probSum);
xlabel('(bps)');
ylabel('Probability');

set(gca, 'XTickLabel',{ [num2str(minxpr,3) '-' num2str(minxpr+1*SizeOfParts,3)], [num2str(minxpr+1*SizeOfParts,3) '-' num2str(minxpr+2*SizeOfParts,3)] ...
    ,[num2str(minxpr+2*SizeOfParts,3) '-' num2str(minxpr+3*SizeOfParts,3)], [num2str(minxpr+3*SizeOfParts,3) '-' num2str(minxpr+4*SizeOfParts,3)] ...
    ,[num2str(minxpr+4*SizeOfParts,3) '-' num2str(minxpr+5*SizeOfParts,3)], [num2str(minxpr+5*SizeOfParts,3) '-' num2str(minxpr+6*SizeOfParts,3)] ...
    ,[num2str(minxpr+6*SizeOfParts,3) '-' num2str(minxpr+7*SizeOfParts,3)], [num2str(minxpr+7*SizeOfParts,3) '-' num2str(minxpr+8*SizeOfParts,3)] ...
    ,[num2str(minxpr+8*SizeOfParts,3) '-' num2str(minxpr+9*SizeOfParts,3)] });

p = polyfit(1:(NoParts-1), probSum, 4 );
fapprox = polyval(p, 1:(NoParts-1));
hold on 
plot(1:(NoParts-1), fapprox,'r');
legend('real data average','approximation')

figure(figMain);
subplot(4,1,4);

%32 seconds
sumtemp = 0;
ads = zeros([1 10]); %average download speed
packetcounter = 1 ;
sumDeyteroleptoy = 0;
prisonDeyteroleptou = 0;
el = 1;
ads(el) = 32*8*1000/ec(2,1) ;
%prison = 0;
limit = 32000;
for ( i = 1 : length(ec(1,:)) )
    sumDeyteroleptoy = sumDeyteroleptoy + ec(2,i) + prisonDeyteroleptou;
    prisonDeyteroleptou = 0;
    if sumDeyteroleptoy < 1000
        continue;
    end
    prisonDeyteroleptou = sumDeyteroleptoy - 1000 ;
    while (sumtemp < limit && ( (i-packetcounter) > 0 ) )
        sumtemp = sumtemp + ec(2,i-packetcounter);
        packetcounter = packetcounter + 1;
    end
   %perasan 8 deyterolepta
%    if sumtemp > limit
%       prison = sumtemp - limit; 
%       el = el + 1;
%       ads(el) = (packetcounter-1)*32*8*1000/limit ;
%    else
      el = el + 1;
      ads(el) = (packetcounter-1)*32*8*1000/sumtemp ;
  % end
   sumtemp = 0;
   packetcounter = 1 ;
   sumDeyteroleptoy = 0;
end

plot((1:el),ads);
xlabel('seconds');
ylabel('(bps)');

figure('Name', [echoFile  '%s Probability functions (average speed from 32 seconds) ' ] );
subplot(2,1,1);


adsort = sort(ads) ; %ta deigmata

counter = 1;
xprob = ones([2 2]);
xprob(1,1) = adsort(1);
i = 2;
while i<length(adsort)
    if adsort(i) == adsort(i-1)
        xprob(2,counter) = xprob(2,counter) + 1; 
    else
        counter = counter + 1;
        xprob(1,counter) = adsort(i);
        xprob(2,counter) = 1;
    end
    i = i + 1;
end

xprob(2,:) = xprob(2,:)/length(adsort);
bar(xprob(1,:), xprob(2,:));
title('Download Rate Probability');
xlabel('(bps)');
ylabel('Probability');
%na fainetai kalytera
NoParts = 10;
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

subplot(2,1,2);
bar(1:(NoParts-1), probSum);
xlabel('(bps)');
ylabel('Probability');

set(gca, 'XTickLabel',{ [num2str(minxpr,3) '-' num2str(minxpr+1*SizeOfParts,3)], [num2str(minxpr+1*SizeOfParts,3) '-' num2str(minxpr+2*SizeOfParts,3)] ...
    ,[num2str(minxpr+2*SizeOfParts,3) '-' num2str(minxpr+3*SizeOfParts,3)], [num2str(minxpr+3*SizeOfParts,3) '-' num2str(minxpr+4*SizeOfParts,3)] ...
    ,[num2str(minxpr+4*SizeOfParts,3) '-' num2str(minxpr+5*SizeOfParts,3)], [num2str(minxpr+5*SizeOfParts,3) '-' num2str(minxpr+6*SizeOfParts,3)] ...
    ,[num2str(minxpr+6*SizeOfParts,3) '-' num2str(minxpr+7*SizeOfParts,3)], [num2str(minxpr+7*SizeOfParts,3) '-' num2str(minxpr+8*SizeOfParts,3)] ...
    ,[num2str(minxpr+8*SizeOfParts,3) '-' num2str(minxpr+9*SizeOfParts,3)] });

p = polyfit(1:(NoParts-1), probSum, 4 );
fapprox = polyval(p, 1:(NoParts-1));
hold on 
plot(1:(NoParts-1), fapprox,'r');
legend('real data average','approximation')


%ayth thn stigmh exw gia kathe paketo ton meso oro toy gia ta 8 prohgoymena
%deyterolepta
%prepei na to apokthsw gia kathe deyterolepto
%synepws apla diagrafw merika stoixeia : 


result = ec; 
end

