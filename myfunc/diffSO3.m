function varargout = diffSO3(R_ref,R_move,ref)
% Move F_move to F_ref
% ref: 'world' or 'self', transformation ref frame
% 
% [dw,mag] = diffmx(R_ref,R_move,'self')
% mag = diffmx(R_ref,R_move,'self')
%  mag = diffmx(R_ref,R_move,'world')
%
% Rotate in World Frame:
% dR * R_move = R_ref , left multp is rot about world
% dR = R_ref * inv(R_move)
% 
% Rotate in Self Frame:
% R_move * dR = R_ref , right multp is rot about self
% dR = inv(R_move) * R_ref
p = size(R_ref,3);

if p==1
    if strcmpi(ref,'world')
        dR = R_ref(1:3,1:3)*R_move(1:3,1:3)';
    elseif strcmpi(ref,'self')
        dR = R_move(1:3,1:3)'*R_ref(1:3,1:3);
    end
else
    if strcmpi(ref,'world')
        dR = pagemtimes(R_ref,pagectranspose(R_move));
    elseif strcmpi(ref,'self')
        dR = pagemtimes(pagectranspose(R_move),R_ref);
    end
end

dw = ExpRotInv(dR);
mag = sqrt(sum(dw.^2));

if nargout == 0 || nargout == 1
    varargout{1} = mag;
elseif nargout == 3
    varargout{1} = dw;    
    varargout{2} = mag;  
end

end