function msg = decode(sig_received,fs,pulse)

narginchk(2, 3);
% check for arguments passed in
if nargin == 3 && pulse == "triangle"
    p = linspace(0,1,fs*0.5+1); %triangle wave
    pulseLength = length(p);
elseif nargin == 3 && pulse == "sine"
    t = 0:(fs*0.5);
    p = sin(((2*pi)/50)*t);
    pulseLength = length(p);
elseif nargin == 3 && pulse == "impulse"
    p = zeros(1, fs*0.5+1);
    p(1:5:end) = 1;
    pulseLength = length(p);
elseif nargin == 2 || pulse == "square"
    pulse = 'square';
    pulseLength = 1 + (0.3*fs); %duration 0.3s times sample rate
    p = ones(1,pulseLength); %generate pulse using ones array
else
    error('Number or content of arguments is invalid')
end

%flip pulse and convolve with received signal
c = conv(sig_received,fliplr(p),'valid'); 

TotalBits = floor(length(sig_received)/pulseLength);

%create empty array of zeros
bits = zeros(1,TotalBits);
for i = 1:TotalBits
    num = c((i-1) * pulseLength + 1);
    if num > 0 % checking if the value at each period is greater than 0
        bits(i) = 1; %change the value of the zero to a one if conv is high
    end
end

%8 bits = 1 btye, convert the number of bits into bytes
TotalBytes = floor(TotalBits/8);

%Create a new array to arrange the bytes
bytes = zeros(1,TotalBytes);
for i = 1:TotalBytes
    for j = 1:8 %changing the bits in each byte into ones where appropriate
        bytes(i) = bytes(i) + 10^(8-j) * bits((i-1) * 8+j);
    end
end

%Now we change the bytes into ascii code by reading the ascii.code file
code = fopen('ascii.code');
column = textscan(code, '%c%c%d');
column{1}(1) = ' ';
column{2}(1) = ':';
fclose(code);

msg = '';
for i = 1:TotalBytes
    msg = [msg, column{1}(find(column{3} == bytes(i)))];
end

end

