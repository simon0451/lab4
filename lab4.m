%% Header
% Lab 5
% Simon Popecki
% 1 April 2017
% Note that the recorded RPMs are the results of a gear system - 1000 RPM
% is really 3160 RPM (factore of 3.16)

%% Engine Information
displacement = 38.1; %engine displacement, ci (two cylinder engine)
l = 4.55; %connecting rod length, in
bore = 3.03; %cylinder bore, inches
stroke = 2.64; %piston stroke, inches
compressionRatio = 8.5; %[NUM]:1, compression ratio of the engine
cylNum = 2; %Number of cylinders

%% Deliverable 1 Part a

% Optical sensor output voltage vs. time, crank angle (in radians) vs. time,
% cylinder volume vs. time, and pressure vs. time for five cycles in four 
% stacked plots for a single engine speed. b

%importing structured arrays
nheaderlines = 22; %Data starts on line 23
dataName = '1000 RPM';
fileName = '1000rpm.lvm';
impStruct = importdata(fileName,'\t',nheaderlines); %data for the balloon with long tube
impData = impStruct.data; %taking only the shit we care about
time = impData(:,1); %time in column three is the same
time = time(1:2000); %we are only looking at 5 cycles
time = time-(time(1));

pDataV = impData(:,2); %Pressure sensor data, in voltage
pDataV = pDataV(1:2000); %taking only first 5 cycles
pData = pDataV/.0104; %converting pressure readings to psi
oData = impData(:,4); %Optical sensor voltage data
oData = oData(1:2000); %taking only the first 5 cycles

[pks,~,TDCs,~] = peaks(time,oData,1); %finding the peak locations of TDC
TDC = TDCs(1); %defining the first spike as TDC
tp1 = TDCs(2); %defining the second spike as tp1 (see ICE Lab overview.pdf)
tp2 = TDCs(3); %defining the third spike as tp2
[~,~,cycleStarts,~] = peakdet(oData,1);

crankAngle = (1-(mod((tp2-(time)),(tp2-tp1)))); 
crankAngle = 2*pi*((crankAngle-min(crankAngle))/(max(crankAngle)-min(crankAngle))); %normalizing and rescaling the crank angle

Vd = displacement/cylNum; %the volume of the combustion chamber at BDC

Vc = Vd/(compressionRatio-1); %clearance volume (cubic inches) 
% - the volume of the cylinder when the piston is at TDC

a = stroke/2; %inches, finding the radius of crankshaft

R = l/a; %ratio of the length of the connecting rod to the radius of the crankshaft

cylinderVolume = Vc.*(1+.5.*(compressionRatio-1).*(R+1-cos(crankAngle)-((R.^2)-(sin(crankAngle).^2)).^.5));

figure(1)
subplot(4,1,1)
plot(time,oData)
title('Engine Data: 3160 RPM')
legend('Optical Sensor Voltage')
xlabel('Time (s)')
ylabel('Voltage (V)')
grid on
xmin = 0;
xmax = .2;
ymin = 0;
ymax = 4.5;
axis ([xmin xmax ymin ymax])
text(.03*xmax,.9*ymax,'Peaks Indicate TDC')


subplot(4,1,2)
plot(time,crankAngle)
legend('Crank Angle')
xlabel('Time (s)')
ylabel('Crank Angle (rad)')
grid on
xmin = 0;
xmax = .2;
ymin = 0;
ymax = 7;
axis ([xmin xmax ymin ymax])

subplot(4,1,3)
plot(time,cylinderVolume)
legend('Cylinder Volume')
xlabel('Time (s)')
ylabel('Cylinder Volume (ci)')
grid on
xmin = 0;
xmax = .2;
ymin = 0;
ymax = 25;
axis ([xmin xmax ymin ymax])

subplot(4,1,4)
plot(time,pData)
legend('Chamber Pressure')
xlabel('Time (s)')
ylabel('Pressure (psi)')
grid on
xmin = 0;
xmax = .2;
ymin = -100;
ymax = 500;
axis ([xmin xmax ymin ymax])

%% Deliverable 1 Part b

startIndex = cycleStarts(1); %TDC of the beginning of a cycle
endIndex = cycleStarts(3); %TDC of the next cycle
scTime = 



