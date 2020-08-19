%% init_param Bdot control
addpath('../Common'); 
deg2rad             = pi/180;
dm.init.epochUTC    = [2022 3 21 0 0 0];
% dm.init.dut1      = -204.8704e-3; %sec
% dm.init.epochUT1 = [dm.init.epochUTC(1:5) dm.init.epochUTC(6)+dm.init.dut1];
dm.init.jd0         = DateTime2JD(dm.init.epochUTC);
dm.init.duration    = 24000;

%% Orbit Prop
dm.init.mu_e        = 3.986004418e14;                           % m^3/s^2
dm.init.PVi0      = [6978.037188 -34.231166 -14.873716...
                      0.039610 6.191067 4.334794]*1000;       % i = 35, m, m/s
% dm.init.PVi0        = [6978.037188 -34.231166 -14.873716...
%                         0.040349 7.102045 2.584696]*1000;       % i = 20, m, m/s
orbitN              = cross(dm.init.PVi0(1:3),dm.init.PVi0(4:6));
dm.init.orbitN      = orbitN/norm(orbitN);  
STK_sun_vector      = [148980720.442646 102875.230468 43821.505096];
dm.init.sun         = STK_sun_vector/norm(STK_sun_vector);
clear orbitN STK_sun_vector

%% Magnetic Dipole Model (mpm)
% IGRF_2020
dm.init.mpm.g10     = -29404.8e-9;  %T
dm.init.mpm.g11     =  -1450.9e-9;  %T
dm.init.mpm.h11     =   4652.5e-9;  %T

%% Spacecraft Model
dm.init.hrw0        = [0 -2 0]';                % wheel angular momentum in Nms
% dm.init.hrw0        = [0 0 0]';                % wheel angular momentum in Nms
dm.init.Nb0         = zeros(3,1);               % external torque in Nm      
dm.init.MoIflag = 1;
if dm.init.MoIflag == 0
        dm.init.Ib  = [ 134.2    -0.7     2.0;  % trim = 0; moment of inertia in kg.m^2
                       -0.7    79.3     4.6;
                        2.0     4.6   203.0];
elseif dm.init.MoIflag == 1
        dm.init.Ib  = [ 134.2    -0.7     2.0;  % trim = -35; moment of inertia in kg.m^2
                       -0.7   110.7    53.1;
                        2.0    53.1   169.3];
elseif dm.init.MoIflag == 2
        dm.init.Ib  = [ 102.8   52.8     2.0;   % trim = -35; moment of inertia in kg.m^2
                       52.8   110.6    -0.4;
                        2.0    -0.4   298.5];
else
        Ibus = 341.3/12*[1000^2+1075^2 1000^2+1075^2 1000^2+1000^2];
        Isp  = 11/12*[1000^2+20^2 2000^2+20^2 2000^2+1000^2];
        I_dia= Ibus+2*Isp;
end
dm.init.w0          = [1.5 -2.5 0]'*deg2rad;         % initial body rates in rad/sec
dm.init.Qi2b0       = [1 0 0 0]';               % initial attitude ECI to Body
dm.init.L0          = dm.init.Ib*dm.init.w0+dm.init.hrw0;                 % initial SC angular momentum
dm.init.dt          = 1;                        %sampling time in sec
%% AOCS Paramters
fsw.init.dt          = 1;                       %sampling time in sec
fsw.init_FS.dt          = 1;                       %sampling time in sec
fsw.init_FS.bdot_period = 10;                      %in sec
fsw.init_FS.bdot_gain   = 1.2*10^6;
fsw.init_FS.b_gain      = 1*10^3;
