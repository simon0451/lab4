function [crankAngle] = crank(i,time,cycleStarts)
    for j = cycleStarts(i):cycleStarts(i+1)-1
        tp2 = time(cycleStarts(i+1)-1);
        tp1 = time(cycleStarts(i));
        crankAngle(j) = 2*pi*((tp2-time(j))/(tp2-tp1));
    end
end