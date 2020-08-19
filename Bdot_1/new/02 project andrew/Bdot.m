function Mc = Bdot(B, B_1)
persistent bdot_n_1
bdot_n  = (B-B_1)/dt;
mag     = norm(bdot_n);

if mag~=0
    bdot_n = bdot_n/mag;
end

if isempty(bdot_n_1)
    bdot_n_1 = bdot_n;
    Mc = zeros(3,1);
    return
end

K       = bdot_gain;             
Bdot    = bdot_n;
Mc      = -K.*Bdot;
maxMc   = max(abs(Mc));
if(maxMc>=CMD_THR)
    Mc = CMD_THR*(Mc/maxMc);
end
bdot_n_1 = bdot_n;
 
