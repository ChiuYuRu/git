function PV_eci = Kepler2PV(orbits,mu_e)
%Kepler Orbits 2 PV
%   Detailed explanation goes here

% Transformation matrix from the orbital frame to the inertial frame
% dcm: direction cosine matrix
dcm1 = rotate(-orbits.longi_ascending,3)*rotate(-orbits.inclination,1)*rotate(-orbits.argument_perigee,3);
% mean_motion = sqrt(mu_e/orbits.semimajor_axis^3);
% mean_angle = mean_motion*(time-time_perigee);
mean_angle = orbits.mean_anomoly*pi/180;
% ecc = 0.109*pi/180; %what is this??? shoudn't this be changed?
ecc = mean_angle;
ecc = kepler(mean_angle,orbits.eccentricity,ecc); %¯Å¼Æ¸Ñºâ¥Xecc

% position in orbital frame
pos_p = orbits.semimajor_axis*[cos(ecc) - orbits.eccentricity; sqrt(1-orbits.eccentricity^2)*sin(ecc); 0];
% velocity in orbital frame
vel_p = sqrt(mu_e/(orbits.semimajor_axis*(1-orbits.eccentricity^2)))*[-sin(ecc); cos(ecc) + orbits.eccentricity; 0];

pos_i = dcm1*pos_p; % position in inertial frame
vel_i = dcm1*vel_p; % velocity in inertial frame
PV_eci = [pos_i', vel_i'];
end

