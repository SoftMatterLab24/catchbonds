function [force,disp,time] = calculate_force_disp_fun(afile,bfile)

[x,y,id,~,~,bAtom1,bAtom2,~,bForce,bForcex,bForcey,bForcez,~,~,~] = parse_dump_full_fun(afile,bfile);

dt = 0.00001;
for ii = 1:length(x)
    force(ii) = bForce{ii};
    disp(ii) = abs(x{ii}(1) - x{ii}(2));
    time(ii) = dt*ii;
end

% 
% for ii = 1:length(x)
%     [tmp,isort] = sort(id{ii});
%     x{ii}   = x{ii}(isort);
%     y{ii}   = y{ii}(isort);
%     z{ii}   = z{ii}(isort);
%     id{ii}  = tmp;
% end
% 
% for ii = 1:length(x)
% 
%     nbonds(ii) = length(bAtom1{ii});
% 
%     [~,a1] = ismember(bAtom1{ii},id{ii});
%     [~,a2] = ismember(bAtom2{ii},id{ii});
% 
%     rx = x{ii}(a1)-x{ii}(a2);
%     ry = y{ii}(a1)-y{ii}(a2);
%     rz = z{ii}(a1)-z{ii}(a2);
%     rx(rz<0) = -rx(rz<0);
%     ry(rz<0) = -ry(rz<0);
%     rz(rz<0) = -rz(rz<0);
%     r  = vecnorm([rx ry rz],2,2);
%     ux = rx./r;
%     uy = ry./r;
%     uz = rz./r;
% 
%     fx = bForce{ii}.*ux;
%     fy = bForce{ii}.*uy;
%     fz = bForce{ii}.*uz;
% 
%     fnet  = sqrt(bForcex{ii}.^2 + bForcey{ii}.^2 + bForcez{ii}.^2);
%     fznet = fnet.*uz;
% 
%     zrange = max(z{ii})-min(z{ii});
%     cpz    = zrange/2;
%     cpvec = linspace(cpz-zrange/3,cpz+zrange/3,50);
% 
%     Szz = zeros(length(cpvec),1);
%     CV1 = zeros(length(cpvec),1);
%     for jj = 1:length(cpvec)
%         cpz = cpvec(jj);
% 
%         icross1 = and(z{ii}(a1) < cpz,z{ii}(a2) > cpz);
%         icross2 = and(z{ii}(a1) > cpz,z{ii}(a2) < cpz);
%         icross  = or(icross1,icross2);
% 
%         Szz(jj) = sum(fznet(icross));
%         CV1(jj) = std(fznet(icross))/mean(fznet(icross));
%     end
%     Sz(ii) = mean(Szz);
% 
% end
% 
% fact  = (1e-9)*(1e8);
% force = Sz'*fact;

end
