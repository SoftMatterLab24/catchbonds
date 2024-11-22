function [S] = getVirialStress(rx,ry,rz,bForcex,bForcey,bForcez,x,y,id,bAtom1,bAtom2)
%% Settings 

%add kinetic energy terms
ikin  = false;

%add pairwise energy terms
ipair = false;

% add bond energy terms
ibond = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         BEGIN COMPUTE         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%loop through each timestep
for nn = 1:length(x)
    
    Rx = rx{nn};
    Ry = ry{nn};
    Rz = zeros(length(Rx),1);
    Fx = bForcex{nn};
    Fy = bForcey{nn};
    Fz = zeros(length(Fx),1);

    R = [Rx Ry Rz];
    F = [Fx Fy Fz];

    %BondForce = bForce{nn};
    BondAtom1 = bAtom1{nn};
    BondAtom2 = bAtom2{nn};
    ID = id{nn};

    %loop through atom i
    for ii = 1:length(ID)
       
       %pre-initialize
       Wab(:,:,ii) = zeros(3);
        
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%              BOND             %%%
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       if ~ibond
           continue;
       end
       
       %get bond neighbor indices
       ba1_ind = find(BondAtom1==double(ID(ii)))';
       ba2_ind = find(BondAtom2==double(ID(ii)))';
       
       if isempty([ba1_ind ba2_ind])
          continue;
       end

        bondneighlist = [ba1_ind ba2_ind];
        %loop through atoms j
        for jj = 1:length(bondneighlist)
            jatom = bondneighlist(jj);
            %loop through aa, bb = {x,y,z}
            for aa = 1:3
                for bb = 1:3
                    wab_temp(aa,bb) =  R(jj,aa)*F(jj,bb);
                end
            end
            %add atom j's contribution to atom i tensor
            Wab(:,:,ii) = Wab(:,:,ii) + wab_temp;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%           KINETIC             %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       if ~ikin
           continue;
       end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%           PAIRWISE            %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       if ~ipair
           continue;
       end

    end
    
    S{nn} = Wab/2;

end

end