function varargout = diffSE3(F_ref,F_move,ref)
% Move F_move to F_ref
% ref: 'world' or 'self', transformation ref frame
% 
% [dp,dw,mag] = diffmx(F_ref,F_move,'self')
% [dp,dw] = diffmx(F_ref,F_move,'self')
%  mag = diffmx(F_ref,F_move,'world')
%
% Output:
% dp: 3*n position error
% dw: 3*n rotation error in axis angle
% mag: magnitude of dp and dw, [magnitude(dp);magnitude(dw)]
% If F are 4*4*n, mag will be 2*n vector
%
% Rotate in World Frame:
% dR * R_move = R_ref , left multp is rot about world
% dR = R_ref * inv(R_move)
% dP = P_ref - P_move
% Important, dP ~= translation part of F_ref * inv(F_move)
% Assume One Frame Rotate in World Coordinate, although only rotation, but
% still have difference in position
% 
% Rotate in Self Frame:
% R_move * dR = R_ref , right multp is rot about self
% dR = inv(R_move) * R_ref
% dP = inv(R_move) * (P_ref - P_move), Same vector but in F_move frame
sr = size(F_ref,3);
sm = size(F_move,3);
p = max([sr,sm]);

if sr==1 && sm~=1
    F_ref = ones(1,1,sm).*F_ref;
end

if sr~=1 && sm==1
    F_move = ones(1,1,sr).*F_move;
end

if p==1
    if strcmpi(ref,'world')
        dR = F_ref(1:3,1:3)*F_move(1:3,1:3)';
        dp = F_ref(1:3,4) - F_move(1:3,4);
    elseif strcmpi(ref,'self')
        dR = F_move(1:3,1:3)'*F_ref(1:3,1:3);
        dp = F_move(1:3,1:3)'*(F_ref(1:3,4) - F_move(1:3,4));
    end
else
    if strcmpi(ref,'world')
        dR = pagemtimes(F_ref(1:3,1:3,:),pagectranspose(F_move(1:3,1:3,:)));
        dp = F_ref(1:3,4,:) - F_move(1:3,4,:);
    elseif strcmpi(ref,'self')
        dR = pagemtimes(pagectranspose(F_move(1:3,1:3,:)),F_ref(1:3,1:3,:));
        dp = pagemtimes(pagectranspose(F_move(1:3,1:3,:)),...
            (F_ref(1:3,4,:)-F_move(1:3,4,:)));
    end
end
dp = reshape(dp,3,p);

dw = ExpRotInv(dR);
mag = [sqrt(sum(dp.^2));sqrt(sum(dw.^2))];

if nargout == 1 || nargout == 0
    varargout{1} = mag;
elseif nargout == 2
    varargout{1} = dp;
    varargout{2} = dw;
elseif nargout == 3
    varargout{1} = dp;
    varargout{2} = dw;    
    varargout{3} = mag;  
end

end