function E = kepler(M,e,E0) % mean_angle,orbits.eccentricity,ecc
E = M + e*sin(E0);
% eccentric anomaly = mean anomaly + eccentricity * sin(eccentric anomaly)
for ii = 1:8
    E = M + e*sin(E);
   
end
