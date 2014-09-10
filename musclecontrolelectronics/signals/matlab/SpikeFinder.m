function [spiketimes]=SpikeFinder(t,d,samplerate,spikewidth,plotting);
%   Function for thresholding spikes
%   by Blythe Towal
%   
%   spiketimes  = SpikeFinder(t,d,samplerate,spikewidth,plotting);
%
%   t           = time data that matches data vector d
%   d           = data vector with neural data including spikes
%   samplerate  = the sampling rate at which the data was acuired (Hz)
%   spikewidth  = the average width of a spike. (usually 2e-3 sec)
%   plotting    = 1 if you want plots, 0 if not

%assign default variables
if nargin < 3
    samplerate=4000;%in Hertz
    spikewidth=2e-3;%time in seconds to # pts
    plotting = 0;
end
    
time=t; 
data=d;
spikewidth=spikewidth*samplerate;%time in seconds to # pts

%bandpass filter first to remove any low frequency artifact
data2=bpfft(data(:,1),samplerate,300,10000);

%plot original data after filtering.
if plotting
    figure;
    set(gcf,'Position',[ 4,481,1019,217]);
    plot(time,data2);ho;
end

%thresholds
noisethresh=2*std(data2);
spikethresh=1.5*noisethresh;

%threshold at a set level
possiblespikes=find(data2>spikethresh | data2<-spikethresh);

%clean possible spikes to get rid of duplicates

%find one spike in each group
dumspikes=possiblespikes(find(diff(possiblespikes)>spikewidth));

%use that one spike as an index to find 
%   the maximum spike in the group
for i=1:length(dumspikes)-1
    maxingroup=find(max( abs( data2(dumspikes(i)+1:dumspikes(i+1)) ))...
        == abs(data2(dumspikes(i)+1:dumspikes(i+1))));
    spiketimes(i)=time(maxingroup+dumspikes(i));
end

%plot the spike times on the neural trace.
if plotting    
    vline(spiketimes,'g');
end
    