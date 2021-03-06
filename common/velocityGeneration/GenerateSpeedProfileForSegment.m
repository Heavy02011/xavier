
function [posDesired,UxDesired,AxDesired,AxMax] = GenerateSpeedProfileForSegment(speedLim,AxDesired, veh,mu,sigma,Fv2,G,Mv2,Mvdot,theta,jerkLimit,brakeFactor,x_0,x_end)

    n = length(sigma);
    %     % Integrate backwards from minimum speed point to find safe upper bound on
    %     % speed accounting for turning limits and deceleration limits
    %     [~,IDX] = min(speedLim);
    %     pos = mod(IDX+1,n);
    %     endPos = mod(IDX,n);

    % integrate backward from last position of current segment with the desired
    % final speed that has been calculated with knowledge of the full map
    IDX = n-1;
    pos = IDX+1;
    endPos = IDX;

    %     if pos ~= 1
    %         [posDesired,UxDesired, AxDesired ] = IntegrateBackwardForSegment(sigma(2)-sigma(1),n,x_end(1),AxDesired(IDX),veh,[mu(pos:n) mu(1:endPos)],[sigma(pos:n) sigma(1:endPos)],...
    %             [Fv2(:,pos:n) Fv2(:,1:endPos)],[G(:,pos:n) G(:,1:endPos)],[Mv2(2:3,pos:n) Mv2(2:3,1:endPos)],...
    %             [Mvdot(2:3,pos:n) Mvdot(2:3,1:endPos)],[theta(pos:n) theta(1:endPos)],jerkLimit,[speedLim(pos:n) speedLim(1:endPos)],brakeFactor);
    %     else
    [posDesired,UxDesired, AxDesired ] = IntegrateBackwardForSegment(sigma(2)-sigma(1),n,x_end(1),AxDesired(IDX),veh,mu,sigma,...
        Fv2,G,Mv2(2:3,:),Mvdot(2:3,:),theta,jerkLimit,speedLim,brakeFactor);
    %     end


    % return points to normal order
    [posDesired,I] = sort(posDesired);
    UxDesired = UxDesired(I);
    AxDesired = AxDesired(I);



    % Integrate forwards acounting for friction limits
    pos = mod(IDX,n);
    endPos = mod(IDX-1,n);
    %     if pos ~= 1
    %         [posDesired,UxDesired, AxDesired, AxMax] = IntegrateForwardForSegment(sigma(2)-sigma(1),[posDesired(pos:n) posDesired(1:endPos)],[UxDesired(pos:n) UxDesired(1:endPos)], [AxDesired(pos:n) AxDesired(1:endPos)],veh ,[mu(pos:n) mu(1:endPos)],...
    %             [Fv2(:,pos:n) Fv2(:,1:endPos)],[G(:,pos:n) G(:,1:endPos)],[Mv2(2:3,pos:n) Mv2(2:3,1:endPos)],[Mvdot(2:3,pos:n) Mvdot(2:3,1:endPos)],[theta(pos:n) theta(1:endPos)],x_0);
    %     else
    [posDesired,UxDesired, AxDesired, AxMax] = IntegrateForwardForSegment(sigma(2)-sigma(1),posDesired,UxDesired, AxDesired,veh,mu, Fv2,G,Mv2,Mvdot,theta,x_0);
    %     end


    % sort back into order from start to end of the path
    [posDesired,I] = sort(posDesired);
    UxDesired = UxDesired(I);
    AxDesired = AxDesired(I);
    AxMax = AxMax(I);

    return % SAMEDIT RETURN HERE, BECAUSE THE NEXT FUNCTION DOESNT WORK FOR MULTIPLE RUNS!!!
    

    % Integrate forwards acounting for current vehicle speed at the beginning
    [posDesired,UxDesired, AxDesired, AxMax] = IntegrateForwardForSegmentMaxDecel(sigma(2)-sigma(1),posDesired,UxDesired, AxDesired,veh,mu, Fv2,G,Mv2,Mvdot,theta,brakeFactor,x_0);
    
    % sort back into order from start to end of the path
    [posDesired,I] = sort(posDesired);
    UxDesired = UxDesired(I);
    AxDesired = AxDesired(I);
    AxMax = AxMax(I);


end