%% init_param Bdot control
addpath('../Common'); 
deg2rad             = pi/180;
dm.init.epochUTC    = [2020 4 21 15 42 56.52];
% dm.init.dut1      = -204.8704e-3; %sec
% dm.init.dut1      = -223.05e-3; %sec why not using this???
% dm.init.epochUT1 = [dm.init.epochUTC(1:5) dm.init.epochUTC(6)+dm.init.dut1];
dm.init.jd0         = DateTime2JD(dm.init.epochUTC);
dm.init.duration    = 24000;

%% Orbit Prop
dm.init.mu_e        = 3.986004418e14;                           % m^3/s^2

%Kepler Elements for RWASAT-1 3U(ISS Deploy)
%Semi-Majer Axis can be calculated from mean motion N 
% a = (u/(2piN/86400)^2)^(1/3); u = 3.986004418¡Ñ10^14
orbits.semimajor_axis = (dm.init.mu_e/((2*pi*15.52248462/86400)^2))^(1/3);        % semimajor axis of the orbit (m) 
orbits.inclination = 51.6461*pi/180;         % orbit inclination in rad
orbits.longi_ascending = 265.8805*pi/180;    % longitude of ascending node in rad(for Geocnentric Orbits LAN = RAAN)
orbits.argument_perigee = 165.3758*pi/180;                    % argument of perigee in rad
orbits.eccentricity = 0.0007448;                        % orbit eccentricity
orbits.mean_anomoly = 301.5916;

%Kepler 3rd law T = 2pi*sqrt(a^3/u); u=GM;
orbits.period = 0.00016587 * (orbits.semimajor_axis/1000)^(3/2)*60 ; % orbit period in sec (90 min)
orbits.rate = 2*pi/orbits.period;   % rad/sec
% orbits.time_perigee = 0;            % time of perigee pass (sec)   %TBD
dm.init.PVi0 = Kepler2PV(orbits,dm.init.mu_e);

% dm.init.PVi0      = [6978.037188 -34.231166 -14.873716...
%                       0.039610 6.191067 4.334794]*1000;       % i = 35, m, m/s
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
% % Reaction Wheel BlueCanyn RWP050
% rw_mdl.maxTorque = 0.007;        % Nm
% rw_mdl.maxAngMom = 0.050;           % Nms
% rw_mdl.moi       = 0.0001;    % kg*m2 ¤j·§¦ôªº0.24kg 58*58*25mm 
dm.init.hrw0        = [0 0.001 0]';                % wheel angular momentum in Nms(pitch bias)
% dm.init.hrw0        = [0 0 0]';                % wheel angular momentum in Nms
dm.init.Nb0         = zeros(3,1);               % external torque in Nm      
dm.init.MoIflag = 1;
dm.init.Ib = diag([0.1477, 0.1137, 0.0567]);        % moment of inertia in kg.m^2
dm.init.w0          = [1.5 -2.5 0]'*deg2rad;         % initial body rates in rad/sec
dm.init.Qi2b0       = [1 0 0 0]';               % initial attitude ECI to Body

% % Ejection Attitude Test
% dm.init.EjectSpd  = 2;    %ejection Speed of PPOD
% dm.init.EjectAng  = 225;    %ejection Angle of PPOD
% dm.init.EjectdV     = dm.init.EjectSpd.*sin(dm.init.EjectAng*deg2rad).*dm.init.PVi0(1:3)./norm(dm.init.PVi0(1:3)) + dm.init.EjectSpd.*cos(dm.init.EjectAng*deg2rad).*dm.init.PVi0(4:6)./norm(dm.init.PVi0(4:6));
% dm.init.PPodPV      = [dm.init.PVi0(1:3),dm.init.PVi0(4:6)+dm.init.EjectdV];
% dm.init.Qi2b0       = PVi2Qi2l(dm.init.PVi0'); % initial attitude ECI to Body

dm.init.L0          = dm.init.Ib*dm.init.w0+dm.init.hrw0;                 % initial SC angular momentum
dm.init.dt          = 1;                        %sampling time in sec
%% AOCS Paramters - FS8, FS8 MOI
% fsw.init_FS.dt          = 1;                       %sampling time in sec
% fsw.init_FS.bdot_period = 10;                      %in sec
% fsw.init_FS.bdot_gain   = 1.2*10^6;
% fsw.init_FS.b_gain      = 1*10^3;
% fsw.init_FS.M_sat_limit = 30;

%% AOCS Paramters - FS8, 6U MOI
% fsw.init_FS.dt          = 1;                       %sampling time in sec
% fsw.init_FS.bdot_period = 10;                      %in sec
% fsw.init_FS.bdot_gain   = 0.6*10^3;
% fsw.init_FS.b_gain      = 0.5*10^0;
% fsw.init_FS.M_sat_limit = 0.2;

%% AOCS Paramters - FS3
fsw.init.dt         = 0.25;                       %sampling time in sec
fsw.init_6u.MTQMax  = 0.2;                        %Amp/m^2
fsw.init_6u.MTQEn   = diag([1,0,1]);              %enable torquer
fsw.init_6u.K_Shift = 1e7;
fsw.init_6u.K_damp   = [0.2;0.2;0.2]*fsw.init_6u.K_Shift.*2;
%fsw.init_6u.K_damp   = [10000;10000;10000];
fsw.init_6u.K_Align  = [0.002;0.002;0.002]*fsw.init_6u.K_Shift;
fsw.init_6u.Alignb  = [1;0;0];