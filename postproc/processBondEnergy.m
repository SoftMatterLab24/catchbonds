function [BondTrajectories] = processBondEnergy(bAtom1,bAtom2,bType,bLength,x,y,id)

% Constants
xi = 0.0014;

eps = 1.0533e-06;
r0 = xi;
lam = 3.8*xi - xi;


for ii = 1:length(bLength)
    ii
    %extract information
    aatom = bAtom1{ii};
    batom = bAtom2{ii};
    type = bType{ii};
    xdata = x{ii};
    ydata = y{ii};

    sortedIDs = NaN(length(id{ii}),1);
    for nn = 1:length(sortedIDs)
        sortedIDs(id{ii}(nn)) = nn;
    end
    
    i_index = sortedIDs(bAtom1{ii}(:));
    j_index = sortedIDs(bAtom2{ii}(:));
        
    cx = (abs(x{ii}(j_index)-x{ii}(i_index))/2 + x{ii}(j_index));
    cy  = (abs(y{ii}(j_index)-y{ii}(i_index))/2 + y{ii}(j_index));

    %extract length of each bond
    BondLength = bLength{ii};
    
    %compute current energy
    Ub = (eps.*(BondLength-r0).^2)./(lam^2 -(BondLength-r0).^2);
    
    %if the first time step - initialize
    if ii == 1
        
        BondTrajectories = zeros([length(BondLength),5+length(bLength)]);
        %idone = zeros(length(BondLength));

        BondTrajectories(:,1) = aatom;
        BondTrajectories(:,2) = batom;
        BondTrajectories(:,3) = type;
        BondTrajectories(:,4) = cx;
        BondTrajectories(:,5) = cy;
        BondTrajectories(:,ii+5) = Ub;

        continue
    end
    
    %construct mirrored test vector
    ab = cellstr(num2str([aatom batom]));
    ba = cellstr(num2str([batom aatom]));

    %construct table
    BondTable = cellstr(num2str([BondTrajectories(:,1) BondTrajectories(:,2)]));
    
    %find if test vector is a member of the Bond Table
    [iab,abloc] = ismember(ab,BondTable);
    [iba,baloc] = ismember(ba,BondTable);
    
    loc = abloc + baloc;
    ifound = any([iab,iba],2);
    
    %insert bond energy if bond already exists
    uinsert = Ub(ifound);
    uloc = loc(loc ~=0);

    BondTrajectories(uloc,ii+5) = uinsert;
    

    %add new bonds
    numberNewBonds2Create = sum(~ifound);
    
    %initialize
    NewBonds = zeros(numberNewBonds2Create,5+length(bLength));
    
    NewBonds(:,1) = aatom(~ifound);
    NewBonds(:,2) = batom(~ifound);
    NewBonds(:,3) = type(~ifound);
    NewBonds(:,4) = cx(~ifound);
    NewBonds(:,5) = cy(~ifound);
    NewBonds(:,ii+5) = Ub(~ifound);

    BondTrajectories = [BondTrajectories; NewBonds];

    %OLD LOOP
    % for jj = 1:length(aatom)
    % 
    %     checkatomA = aatom(jj);
    %     checkatomB = batom(jj);
    %     checktype = type(jj);
    %     checkx = cx(jj);
    %     checky = cy(jj);
    % 
    %     ileft = [checkatomA == BondTrajectories(:,1), checkatomB == BondTrajectories(:,2)];
    %     iright = [checkatomB == BondTrajectories(:,1), checkatomA == BondTrajectories(:,2)];
    %     icombined = [all(ileft,2), all(iright,2)];
    % 
    %     %find corresponding index
    %     bondindex = any(icombined,2);
    % 
    % 
    % 
    %     if  any(bondindex)
    %         BondTrajectories(bondindex,ii+5) =  Ub(jj);
    %     else
    %         %New bond add to trajectries table
    %         BondTrajectories(ind,:) = zeros(1,5+length(bLength));
    % 
    %         BondTrajectories(ind,1) = checkatomA;
    %         BondTrajectories(ind,2) = checkatomB;
    %         BondTrajectories(ind,3) = checktype;
    %         BondTrajectories(ind,4) = checkx;
    %         BondTrajectories(ind,5) = checky;
    %         BondTrajectories(ind,ii+5) = Ub(jj);
    %         ind = ind +1;
    %     end
    % end

%save('BondTrajectories.mat',"BondTrajectories")
end

% u = [0.5 0.6 0.7 0.8];
% 
% aatom = [1 1 1 6]';
% batom = [2 3 5 7]';
% 
% cellstr(num2str([aatom batom]))
% 
% ab = cellstr(num2str([aatom batom]));
% ba = cellstr(num2str([batom aatom]));
% 
% BT1 = [1 2 1]';
% BT2 = [3 1 5]';
% 
% BondTable = cellstr(num2str([BT1 BT2]));
% 
% [iab,abloc] = ismember(ab,BondTable);
% [iba,baloc] = ismember(ba,BondTable);
% 
% loc = abloc + baloc;
% ifound = any([iab,iba],2);
% 
% uinsert = u(ifound);
% uloc = loc(loc ~=0);
% 
% Utable(uloc) = uinsert;

%add new
