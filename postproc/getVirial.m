function [rx,ry,r,ux,uy] = getVirial(x,y,id,ty,mol,bAtom1,bAtom2,bLength,bForce,bForcex,bForcey,bForcez,bEngpot,xlims,ylims,zlims)

% sort through atoms by id
for ii = 1:length(x)
    [tmp,isort] = sort(id{ii});
    x{ii}   = x{ii}(isort);
    y{ii}   = y{ii}(isort);
    %z{ii}   = z{ii}(isort);
    id{ii}  = tmp;
end

for jj = 1:length(x)

    [~,a1] = ismember(bAtom1{jj},id{jj});
    [~,a2] = ismember(bAtom2{jj},id{jj});

    rx{jj} = x{jj}(a1)-x{jj}(a2);
    ry{jj} = y{jj}(a1)-y{jj}(a2);
    
    r{jj}  = vecnorm([rx{jj} ry{jj}],2,2);
    ux{jj} = rx{jj}./r{jj};
    uy{jj} = ry{jj}./r{jj};
end

end
