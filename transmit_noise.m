function [signal, received] = transmit_noise(fs,pulse)

msg = 'covid-19';

narginchk(1, 2);
% check for arguments passed in
if nargin == 2 && pulse == "triangle"
    p = linspace(0,1,fs*0.5+1); %triangle wave
    pulseLength = length(p);
elseif nargin == 2 && pulse == "sine"
    t = 0:(fs*0.5);
    p = sin(((2*pi)/50)*t);
    pulseLength = length(pulse);
elseif nargin == 2 && pulse == "impulse"
    p = zeros(1, fs*0.5+1);
    p(1:5:end) = 1;
    pulseLength = length(p);    
elseif nargin == 1 || pulse == "square"
    pulse = 'square';
    pulseLength = 1 + (0.3*fs); %duration 0.3s times sample rate
    p = ones(1,pulseLength); %generate pulse using ones array
else
    error('Number of arguments is invalid');
end


code = fopen('ascii.code');
column = textscan(code, '%c%c%s');
column{1}(1) = ' ';
column{2}(1) = ':';
fclose(code);

TotalBytes = length(msg);
TotalBits = 8 * length(msg);
bits = zeros(1,TotalBits);

for i = 1:TotalBytes
    %each ascii value from the message will be stored as a string of bits
    ascii = column{3}{find(column{1} == msg(i)')};
    for j = 1:8 %number of bits in a byte
        bits((i-1)*8+j) = str2num(ascii(j));
    end
end

%Create the original signal by starting with an array of zeros and filling
%in ones where appropriate
pulseLength = length(p);
original = zeros(1,TotalBits*pulseLength);
for i = 1:TotalBits
    if bits(i) == 1 %when a bit is 1, we want to use the positive pulse
        original(((i-1)*pulseLength+1):(i*pulseLength)) = p;
    else %when a bit is 0, we want to use the negative pulse
        original(((i-1)*pulseLength+1):(i*pulseLength)) = -1.*p;
    end
end

%add noise to original signal and plot
noise = zeros(1,length(original)); 
noise(1,:) = original + randn(size(original));%adds noise 

x = 1:TotalBits*pulseLength;
figure(1);
plot(x,original);
title('Original Signal');
xlabel('# of samples');
ylabel('Received Signal');

figure(2);
plot(x,noise);
title('Noise + Original Signal');
xlabel('# of samples');
ylabel('Random Noise');


signal = decode(noise, fs, pulse);

%Creating noisy signals that gradually increase
newnoises = zeros(1,length(original));
received = cell(1,30);
for i = 1:30
    newnoises(i,:) = original + (i/10)*randn(size(original));
    received{i} = decode(newnoises(i,:),fs,pulse);
    disp(received{i});
end


end