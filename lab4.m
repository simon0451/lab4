%% Header
% Lab 5
% Simon Popecki
% 1 April 2017
% Note that the recorded RPMs are the results of a gear system - 1000 RPM
% is really 2,528 RPM (factore of 3.16)

clear all;
close all;
%% Engine Information
displacement = 38.1; %engine displacement, ci (two cylinder engine)
l = 4.55; %connecting rod length, in
bore = 3.03; %cylinder bore, inches
stroke = 2.64; %piston stroke, inches
compressionRatio = 8.5; %[NUM]:1, compression ratio of the engine
cylNum = 2; %Number of cylinders

%% Deliverable 1 Part a

% Optical sensor output voltage vs. time, crank angle (in radians) vs. time,
% Chamber Volume vs. time, and pressure vs. time for five cycles in four 
% stacked plots for a single engine speed. b

%importing structured arrays
nheaderlines = 22; %Data starts on line 23
fileName = '800rpm.lvm';
impStruct = importdata(fileName,'\t',nheaderlines); %data for the balloon with long tube
impData = impStruct.data; %taking only the shit we care about
time = impData(:,1); %time in column three is the same
% time = time(1:2000); %we are only looking at 5 cycles
time = time-(time(1));

pDataV = impData(:,2); %Pressure sensor data, in voltage
% pDataV = pDataV(1:2000); %taking only first 5 cycles
pData = pDataV/.0104; %converting pressure readings to psi
oData = impData(:,4); %Optical sensor voltage data
% oData = oData(1:2000); %taking only the first 5 cycles

[pks,~,TDCs,~] = peaks(time,oData,1); %finding the peak locations of TDC
% TDC = TDCs(1); %defining the first spike as TDC
% tp1 = TDCs(1); %defining the second spike as tp1 (see ICE Lab overview.pdf)
% tp2 = TDCs(2); %defining the third spike as tp2
[~,~,cycleStarts,~] = peakdet(oData,1); %cycleStarts is referenced later in the program

crankAngle = zeros(length(time),1);
for i = 1:1:20
    for j = cycleStarts(i):cycleStarts(i+1)-1
        tp2 = time(cycleStarts(i+1)-1);
        tp1 = time(cycleStarts(i));
        crankAngle(j) = 2*pi*(1-((tp2-time(j))/(tp2-tp1)));
        
    end
end

Vd = displacement/cylNum; %the volume of the combustion chamber at BDC

Vc = Vd/(compressionRatio-1); %clearance volume (cubic inches) 
% - the volume of the cylinder when the piston is at TDC

a = stroke/2; %inches, finding the radius of crankshaft

R = l/a; %ratio of the length of the connecting rod to the radius of the crankshaft

cylinderVolume = Vc.*(1+.5.*(compressionRatio-1).*(R+1-cos(crankAngle)-((R.^2)-(sin(crankAngle).^2)).^.5));

time = time(cycleStarts(1):cycleStarts(20));
time = time-time(1); %rezeroing the new time
pData = pData(cycleStarts(1):cycleStarts(20));
oData = oData(cycleStarts(1):cycleStarts(20));
cylinderVolume = cylinderVolume(cycleStarts(1):cycleStarts(20));
crankAngle = crankAngle(cycleStarts(1):cycleStarts(20));

figure(1)
subplot(4,1,1)
plot(time,oData)
title('Engine Data: 2,528 RPM')
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
legend('Chamber Volume')
xlabel('Time (s)')
ylabel('Chamber Volume (ci)')
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
ymax = 550;
axis ([xmin xmax ymin ymax])

%% Deliverable 1 Part b

startIndex = cycleStarts(1); %TDC of the beginning of a cycle
endIndex = cycleStarts(3); %TDC of the next cycle
sctime = time(startIndex:endIndex); %a new time array looking at only a single cycle
sctime = sctime - sctime(1); %rezeroing time to begin at the first TDC

%Corresponding values of interest for this new time interval
sccrankAngle = crankAngle(startIndex:endIndex);
scoData = oData(startIndex:endIndex);
sccylinderVolume = cylinderVolume(startIndex:endIndex);
scpData = pData(startIndex:endIndex);

% figure(2)
% subplot(4,1,1)
% plot(sctime,scoData)
% title('Single Cycle Data: 2,528 RPM')
% legend('Optical Sensor Voltage','location','southeast')
% xlabel('Time (s)')
% ylabel('Voltage (V)')
% grid on
% xmin = 0;
% xmax = .039;
% ymin = 0;
% ymax = 4.5;
% axis ([xmin xmax ymin ymax])
% text(.03*xmax,.9*ymax,'Peaks Indicate TDC')
% 
% 
% subplot(4,1,2)
% plot(sctime,sccrankAngle)
% legend('Crank Angle','location','southeast')
% xlabel('Time (s)')
% ylabel('Crank Angle (rad)')
% grid on
% xmin = 0;
% xmax = .039;
% ymin = 0;
% ymax = 7;
% axis ([xmin xmax ymin ymax])
% 
% subplot(4,1,3)
% plot(sctime,sccylinderVolume)
% legend('Chamber Volume','location','southeast')
% xlabel('Time (s)')
% ylabel('Chamber Volume (ci)')
% grid on
% xmin = 0;
% xmax = .039;
% ymin = 0;
% ymax = 25;
% axis ([xmin xmax ymin ymax])
% 
% subplot(4,1,4)
% plot(sctime,scpData)
% legend('Chamber Pressure','location','southeast')
% xlabel('Time (s)')
% ylabel('Pressure (psi)')
% grid on
% xmin = 0;
% xmax = .039;
% ymin = -100;
% ymax = 550;
% axis ([xmin xmax ymin ymax])

%plotting the P-V diagram for the combustion chamber
figure(3)
plot(sccylinderVolume,scpData)
title('Representative Single Cycle at 2,528 RPM')
xlabel('Chamber Volume (ci)')
ylabel('Chamber Pressure (psi)')
grid on

%% Deliverable 1 Part c

%plotting all the P-V diagrams on top of each other to get the average

figure(4)
plot(cylinderVolume,pData)
title('All Cycles at 2,528 RPM')
xlabel('Chamber Volume (ci)')
ylabel('Chamber Pressure (psi)')
grid on

%% Deliverable 2 
[avgW400,avgP400,stdW400,stdP400] = del2('400rpm.lvm');
[avgW500,avgP500,stdW500,stdP500] = del2('500rpm.lvm');
[avgW600,avgP600,stdW600,stdP600] = del2('600rpm.lvm');
[avgW700,avgP700,stdW700,stdP700] = del2('700rpm.lvm');
[avgW800,avgP800,stdW800,stdP800] = del2('800rpm.lvm');
[avgW900,avgP900,stdW900,stdP900] = del2('900rpm.lvm');
[avgW1000,avgP1000,stdW1000,stdP1000] = del2('1000rpm.lvm');
[avgW1100,avgP1100,stdW1100,stdP1100] = del2('1100rpm.lvm');

%% Deliverable 3
%Assuming all the energy in the fuel gets converted to work

%mass of fuel burned per some time interval for each engine speed
fb1100 = 13215-13151;
fb1000 = 13090-13003;
fb900 = 12940-12865;
fb800 = 12828-12762;
fb700 = 12730-12670;
fb600 = 12615-12565;
fb500 = 12544-12501;
fMass = [fb1100; fb1000; fb900; fb800; fb700; fb600; fb500;]; %first element in this array is the highest speed
timeInt = 60; %seconds, the time interval of the test
gassMass = fMass/timeInt; %the mass of gasoline burned per second for each RPM (g/s)

RPMs = [1100; 1000; 900; 800; 700; 600; 500;]*3.16; %engine RPMs corresponding to the fuel burn rates
RPSs = RPMs/60; %engine speed, converting these values to rotations per second
massPerCycle = (gassMass./RPSs)/2; %grams per rotation - the amount of fuel burned per thermodynamic cycle, per cylinder.
% Divided by two because every other mechanical cycle is a combustion cycle
% (4-stroke).

airMassPerCycle = massPerCycle.*14.7; %finding how many grams of air are inhaled per thermodynamic cycle

%computing the heat released per cycle
gasSE = 44; %kJ/g, specific energy of gasoline
heatPerCycle = massPerCycle.*gasSE; %kilojoules of heat released per cycle assuming complete combustion per cyl.
heatPerSec = heatPerCycle.*RPSs; %kilojoules per second (kW) per cyl
heatPerSeci = heatPerSec*1.34102; %converting heat power into mechanical horsepower

%calculating brake thermal efficiency
avgPowers = [avgP1100; avgP1000; avgP900; avgP800; avgP700; avgP600; avgP500;]; %hp, both cylinders
brakeThermalEfficiency = (avgPowers)./(heatPerSeci.*3.16); %computing the thermal efficiency (factoring gear ratio)

%calculating mechanical efficiency
dynoPowers = [12.6; 17.5; 16.3; 14.5; 12.5; 10.2; 8.1;];
mechEff = dynoPowers./avgPowers;

%% Deliverable 4

% plotting power and torque curves

torques = [19.1; 29.1; 30.2; 30.2; 29.6; 28.2; 26.7;];
maxTorque = max(torques);
maxPower = max(dynoPowers);

maxTorqueST = num2str(maxTorque,3);
maxPowerST = num2str(maxPower,3);

txt = strcat('Max. Power: ',maxPowerST,' (bhp)');
txt2 = strcat('Max. Torque: ',maxTorqueST,' (ft-lbs)');

figure(6)
yyaxis left
plot(RPMs,dynoPowers)
title('Power and Torque Curves for Kohler CH20S Engine')
xlabel('Engine Speed (RPM)')
ylabel('Engine Power (bhp)')
xmin = 1500;
xmax = 3600;
ymin = 0;
ymax = 18;
axis ([xmin xmax ymin ymax])
text(.78*xmax,.1*ymax,txt)
text(.78*xmax,.15*ymax,txt2)
grid on


yyaxis right
plot(RPMs,torques)
ylabel('Engine Torque (ft-lbs)')
xmin = 1500;
xmax = 3600;
ymin = 0;
ymax = 35;
axis ([xmin xmax ymin ymax])
grid on

%% Deliverable 5 

% Brake thermal efficiency vs. engine speed

figure(7)
plot(RPMs,(brakeThermalEfficiency*100))
title('Kohler CH20S Engine - Thermal Efficiency')
xlabel('Engine Speed (RPM)')
ylabel('Brake Thermal Efficiency (%)')
xmin = 1500;
xmax = 3600;
ymin = 0;
ymax = 100;
axis ([xmin xmax ymin ymax])
grid on


