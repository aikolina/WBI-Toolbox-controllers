%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /**
%  * Copyright (C) 2016 CoDyCo
%  * @author: Daniele Pucci & Marie Charbonneau
%  * Permission is granted to copy, distribute, and/or modify this program
%  * under the terms of the GNU General Public License, version 2 or any
%  * later version published by the Free Software Foundation.
%  *
%  * A copy of the license can be found at
%  * http://www.robotcub.org/icub/license/gpl.txt
%  *
%  * This program is distributed in the hope that it will be useful, but
%  * WITHOUT ANY WARRANTY; without even the implied warranty of
%  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
%  * Public License for more details
%  */
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [desiredTaskAcc,comError,rootRotErr,lFootPosErr,lFootRotErr,rFootPosErr,rFootRotErr, taskAccErr] = ...
              desiredTaskAcceleration(taskPositions, taskVelocities, ...
                                      desComPosVelAcc, desRootRotPosVelAcc, ...
                                      desLFootOriginPosVelAcc, desLFootRotPosVelAcc, ...
                                      desRFootOriginPosVelAcc, desRFootRotPosVelAcc, ...
                                      PDgainsPos, PDgainsRot)
    
                                  
    comPos             = taskPositions(1:3,  4);
    w_R_root           = taskPositions(1:3,1:3);
    
    w_H_l_sole         = taskPositions(5:8,  :);
    w_H_r_sole         = taskPositions(9:12, :);    
    l_solePos          = w_H_l_sole(1:3,4);
    r_solePos          = w_H_r_sole(1:3,4);
    w_R_l_sole         = w_H_l_sole(1:3,1:3);
    w_R_r_sole         = w_H_r_sole(1:3,1:3);
    
    comVel             = taskVelocities( 1: 3);
    rootAngVel         = taskVelocities( 4: 6);
    
    leftFootLinVel     = taskVelocities( 7: 9);
    leftFootAngVel     = taskVelocities(10:12);
    
    rightFootLinVel    = taskVelocities(13:15);
    rightFootAngVel    = taskVelocities(16:18);
    
    gainsPDpos_CoM     = PDgainsPos(1:3, :);
    gainsPDpos_lFoot   = PDgainsPos(4:6, :);
    gainsPDpos_rFoot   = PDgainsPos(7:9, :);
    
    gainsPDrot_root    = PDgainsRot(1,:);
    gainsPDrot_lFoot   = PDgainsRot(2,:);
    gainsPDrot_rFoot   = PDgainsRot(3,:);
       
    comDDotStar        = linearPID(comPos,comVel,desComPosVelAcc,gainsPDpos_CoM);
    rootOmegaDotStar   = rotationalPID(w_R_root,rootAngVel,desRootRotPosVelAcc, gainsPDrot_root); 
    
    lFootPosDDotStar   = linearPID(l_solePos,leftFootLinVel,desLFootOriginPosVelAcc,gainsPDpos_lFoot);
    lFootOmegaDotStar  = rotationalPID(w_R_l_sole,leftFootAngVel,desLFootRotPosVelAcc,gainsPDrot_lFoot);  
    
    rFootPosDDotStar   = linearPID(r_solePos,rightFootLinVel,desRFootOriginPosVelAcc,gainsPDpos_rFoot);
    rFootOmegaDotStar  = rotationalPID(w_R_r_sole,rightFootAngVel,desRFootRotPosVelAcc,gainsPDrot_rFoot);
    
    desiredTaskAcc     = [comDDotStar;
                          rootOmegaDotStar
                          lFootPosDDotStar
                          lFootOmegaDotStar
                          rFootPosDDotStar
                          rFootOmegaDotStar];
    
    comError          = comPos - desComPosVelAcc(:,1);
    rootRotErr        = invSkew(desRootRotPosVelAcc(1:3,1:3)'*w_R_root);
    lFootPosErr       = l_solePos - desLFootOriginPosVelAcc(:,1);
    lFootRotErr       = invSkew(desLFootRotPosVelAcc(1:3,1:3)'*w_R_l_sole);
    rFootPosErr       = r_solePos - desRFootOriginPosVelAcc(:,1);
    rFootRotErr       = invSkew(desRFootRotPosVelAcc(1:3,1:3)'*w_R_r_sole);
    
    taskAccErr = [comError;
                  rootRotErr;
                  lFootPosErr;
                  lFootRotErr;
                  rFootPosErr;
                  rFootRotErr];
        
end