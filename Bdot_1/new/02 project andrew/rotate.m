function dcm = rotate(angle,direction)
%
% Obtain the rotation matrix
%
cosa = cos(angle);
sina = sin(angle);
if ( direction == 1 ),
    dcm = [1 0 0;0 cosa sina; 0 -sina cosa];
elseif ( direction == 2 ),
    dcm = [cosa 0 -sina; 0 1 0;sina 0 cosa];
elseif ( direction == 3 ),
    dcm = [cosa sina 0;-sina cosa 0;0 0 1];
else
    disp(['Error in rotate']);
end;
%
% Jyh-Ching Juang, 2001
%