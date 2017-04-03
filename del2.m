function [avgWork,avgPower,stdWork,stdPower] = del2(fileName)

nheaderlines = 22; %Data starts on line 23
impStruct = importdata(fileName,'\t',nheaderlines); %data for the balloon with long tube
impData = impStruct.data; %taking only the shit we care about
time = impData(:,1); %time in column three is the same
time = time-(time(1));
pDataV = impData(:,2); %Pressure sensor data, in voltage
pData = pDataV/.0104; %converting pressure readings to psi
oData = impData(:,4); %Optical sensor voltage data
[~,~,TDCs,~] = peaks(time,oData,1); %finding the peak locations of TDC
TDC = TDCs(1); %defining the first spike as TDC
tp1 = TDCs(1); %defining the second spike as tp1 (see ICE Lab overview.pdf)
tp2 = TDCs(2); %defining the third spike as tp2
[~,~,cycleStarts,~] = peakdet(oData,1); %cycleStarts is referenced later in the program

crankAngle = zeros(length(time),1);
for i = 1:1:20
    for j = cycleStarts(i):cycleStarts(i+1)-1
        tp2 = time(cycleStarts(i+1)-1);
        tp1 = time(cycleStarts(i));
        crankAngle(j) = 2*pi*((tp2-time(j))/(tp2-tp1));
        
    end
end

displacement = 38.1;
l = 4.55; %connecting rod length, in
bore = 3.03; %cylinder bore, inches
stroke = 2.64; %piston stroke, inches
compressionRatio = 8.5; %[NUM]:1, compression ratio of the engine
cylNum = 2; %Number of cylinders

Vd = displacement/cylNum; %the volume of the combustion chamber at BDC
Vc = Vd/(compressionRatio-1); %clearance volume (cubic inches) 
% - the volume of the cylinder when the piston is at TDC

a = stroke/2; %inches, finding the radius of crankshaft
R = l/a; %ratio of the length of the connecting rod to the radius of the crankshaft
cylinderVolume = Vc.*(1+.5.*(compressionRatio-1).*(R+1-cos(crankAngle)-((R.^2)-(sin(crankAngle).^2)).^.5));

for i = 1:1:10
time1 = time(cycleStarts(i):cycleStarts(i+2));
time1 = time1-time(i+2);
crankAngle1 = crankAngle(cycleStarts(i):cycleStarts(i+2));
cylinderVolume1 = cylinderVolume(cycleStarts(i):cycleStarts(i+2));
pData1 = pData(cycleStarts(i):cycleStarts(i+2));
oData1 = oData(cycleStarts(i):cycleStarts(i+2));

work1(i) = (trapz(cylinderVolume1,pData1));
work(i) = .11*(trapz(cylinderVolume1,pData1)); %this is the work done by two mechanical rotations

% work = work'; %transposing work to make it a column vector (units are in lb-in)
% work = work/12; %UNITS OF WORK ARE NOW IN lb*ft
% angVel = RPM*3.16/2;
cycleTime = time(cycleStarts(i+2))-time(cycleStarts(i));
power(i) = 2*(work(i)/cycleTime)/1000*1.3410220888; %horsepower

power2(i) = (2.*(((work1(i)/12)))./(cycleTime))*60/33000; %American Brake Horsepower (times 2 for two cylinders)
end


avgWork = mean(work1); %average work in lb-ft
avgPower = mean(power2); %average power in bhp
% stdWork = std(work1); %standard deviation of the work values
stdWork = sqrt((sum((work1-avgWork).^2))./(length(work1)-1));
stdPower = std(power2); %standard deviation of the power

end




