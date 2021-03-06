function veh = getVehicle(tireType, mapMatchType)
    veh.a = 1.0441;
    veh.b = 1.4248;
    veh.m = 1.5124e3;
    veh.Cf = 160000;
    veh.Cr = 180000;
    veh.Iz = 2.25e3;
    veh.xLA = 14.2;
    veh.kLK = .0538;
    veh.muF = .97;
    veh.muR = 1.02;
    veh.g = 9.81;
    veh.L = veh.a + veh.b;
    veh.FzF = veh.m*veh.b*veh.g/veh.L;
    veh.FzR = veh.m*veh.a*veh.g/veh.L;
    veh.D = .3638; %drag coefficient
    veh.h = .75; %cg distance above ground;
    
    veh.alphaFlim = 7*pi/180; %for FFW steering in simulation
    veh.alphaRlim = 5*pi/180;
    
    
    veh.alphaFslide = abs( atan(3*veh.muF*veh.m*veh.b/veh.L*veh.g/veh.Cf) );
    veh.alphaRslide = abs( atan(3*veh.muR*veh.m*veh.a/veh.L*veh.g/veh.Cr) );
    
    %veh.alphaFrontTable=[-veh.alphaFslide:.001:veh.alphaFslide];   % vector of front alpha (rad)
    %veh.alphaRearTable =[-veh.alphaRslide:.001:veh.alphaRslide];   % vector of rear alpha (rad)
    nT = 250;
    veh.alphaFrontTable = linspace(-veh.alphaFslide,veh.alphaFslide, nT); 
    veh.alphaRearTable  = linspace(-veh.alphaRslide,veh.alphaRslide, nT);
    
    
    if strcmp(tireType,'linear')
        veh.FyFtable = -veh.Cf*veh.alphaFrontTable;
        veh.FyRtable = -veh.Cr*veh.alphaRearTable;
    elseif strcmp(tireType,'nonlinear')
        veh.FyFtable = tireforces(veh.Cf,veh.muF,veh.muF,veh.alphaFrontTable,veh.FzF);
        veh.FyRtable = tireforces(veh.Cr,veh.muR,veh.muR, veh.alphaRearTable,veh.FzR);
    else
        error('Invalid Tire Type')
    end
    
    veh.mapMatch = mapMatchType;
    veh.tireType = tireType;
    
    veh.brakeTimeDelay = .25; %seconds
    veh.rollResistance = 255; %Newtons
    veh.Kx = 3000; %speed tracking gain
    veh.powerLimit = 160000; %Watts
    
end