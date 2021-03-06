%% icubGazeboSim
ROBOT_DOF = 11;
robotName = 'icub';
localName = 'impedance';
Ts        = 0.01;

KpTorso   = 0.5*ones(1,3);
KpArms    = [0.1,0.1,0.1,0.1];
KpLegs    = [0.5,0.5,0.5,0.5,0.5,0.5];
Kp        = diag([KpTorso,KpArms,KpArms]);

if size(Kp,1) ~= ROBOT_DOF
    error('Dimension of Kp different from ROBOT_DOF')
end

Kd        = 2*sqrt(Kp)*0;

GRAV_COMP = 1;
MOVING    = 0;
AMPLS     = 15*ones(1,ROBOT_DOF);
FREQS     = 0.25*ones(1,ROBOT_DOF);

if MOVING == 1
    simulationTime = inf;%5/FREQS(1);
else
    simulationTime = inf;
end