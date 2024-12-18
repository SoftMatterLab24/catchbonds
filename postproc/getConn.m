function [kglobal,kglobalavg,krigid,krigidavg,nbonds] = getConn(bAtom1,bAtom2,bType,natoms)

    for ii = 1:10%length(bAtom1)
        %% Global Properties
        numatoms = natoms(ii);
        bAtoms = [bAtom1{ii}; bAtom2{ii}];
        %bondedID = unique(bAtoms);

        for jj = 1:numatoms
            kglobal{ii}(jj) = sum(bAtoms == jj);
        end
        
        kglobalavg(ii) = mean(kglobal{ii});
        nbonds(ii) = length(bAtom1{ii});

        %% 
        % get the number of unique bond types
        bTypeIDs = unique(bType{ii});
        numTypes = length(bTypeIDs);

        % count the number of each
        for kk = 1:numTypes
            itype = bType{ii} == bTypeIDs(kk);
            bTypeCount{ii}(kk) = sum(itype);
            
            %get the connectivity of just rigid bonds
            if kk == 1
                bAtoms = [bAtom1{ii}(itype); bAtom2{ii}(itype)];

                for jj = 1:numatoms
                    krigid{ii}(jj) = sum(bAtoms == jj);
                end
                    krigidavg(ii) = mean(krigid{ii});
            end
        end

    end

end
