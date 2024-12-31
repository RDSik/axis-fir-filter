clc
clear

x = [0:2*pi/256:2*pi-2*pi/256];
y1 = sin(x) + 1;
y2 = y1./max(y1);
y3 = ceil(y2.*(2^12-1));

fid1 = fopen('sin.mem', 'wb');
if fid1 == -1
    error('File is not opened');
end

for i = 1:256
    fprintf(fid1, '%s\n', dec2hex(y3(i), 4));
end

fclose(fid1);
