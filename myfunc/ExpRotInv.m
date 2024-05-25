function varargout = ExpRotInv(R)
% Get Axis Angle from Rotation Matrix
% Use SVD to deal with theta=pi case
% Now Support 3D 3*3*n Matrix !
% Avoid for loop, except theta=pi

[r,c,p] = size(R);

if r*c~=9
    error('Only Support 3x3xn Matrix')
end

if p==1
    ct = min(max((trace(R)-1)/2,-1),1);
    theta = acos(ct);
    w = 1/2/sin(theta)*Vee3(R-transpose(R));

    if isa(R,'sym')
        if theta==0
            w = [0,0,0]';
        end
    else
        if abs(theta)<1e-6 || ct>1
            w = [0,0,0]';
            theta=0;
        elseif abs(theta-pi)<1e-6
            [~,~,V] = svd(eye(3)-R);
            w = V(:,end)/norm(V(:,end));
        end
    end
%%
else
    ct = (R(1,1,:)+R(2,2,:)+R(3,3,:)-1)/2;
    ct = max([min([ct,ones(1,1,p)]),-ones(1,1,p)]);
    theta = acos(ct);
    theta = reshape(theta,1,p);
    w = 1/2./sin(theta).*Vee3(R-pagetranspose(R));

    %% Theta = 0, sin(theta)=0
    ind1 = abs(theta)<1e-6;
    ind2 = ct>1;
    ind = (ind1+reshape(ind2,1,p))>0;

    theta(ind) = 0;
    w(:,ind) = 0;

    %% Theta = pi, sin(theta)=0
    ind = find(abs(theta-pi)<1e-6);
    for i = ind
        [~,~,V] = svd(eye(3)-R(:,:,i));
        w(:,i) = V(:,end)/norm(V(:,end));
    end
end

if nargout == 1 || nargout == 0
    varargout{1} = w.*theta;
elseif nargout == 2
    varargout{1} = w;
    varargout{2} = theta;
end

end