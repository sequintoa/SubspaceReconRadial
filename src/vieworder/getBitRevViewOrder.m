function [viewsVec,viewTable] = getBitRevViewOrder(etl,nSpokes)
% Implements a bit-reversed ordering for radial fast spin echo sequences
%
% Details of ordering available in:
% Theilmann, Rebecca J., et al. "View?ordering in radial fast spin?echo
% imaging." Magnetic Resonance in Medicine 51.4 (2004): 768-774.
%
% Mahesh Keerthivasan, 2013
% University of Arizona

nShots = nSpokes / etl;

views = zeros(etl, nShots);
viewsVec = zeros(nSpokes,1);

bit_rev = getBitRevVec(etl);

if etl == 8
    number = nShots;
    if nSpokes == 160
        number = 24;
    elseif nSpokes == 128
        number = 16;
    end
end


idx = 1;
for shotIdx = 1:nShots
    for ecoIdx = 1:etl
        if etl == 4
            views(ecoIdx,shotIdx) = mod((ecoIdx-1)*nShots+bit_rev(ecoIdx)+(shotIdx-1)*etl,nSpokes);
        elseif etl == 8
            views(ecoIdx,shotIdx) = mod((ecoIdx-1)*number+bit_rev(ecoIdx)+(shotIdx-1)*etl,nSpokes);
        elseif etl >= 16
            views(ecoIdx,shotIdx) = mod((ecoIdx-1)*etl+bit_rev(ecoIdx)+(shotIdx-1)*etl,nSpokes);
        end
        viewsVec(idx) = views(ecoIdx,shotIdx);
        idx = idx + 1;
    end
end

viewTable = views';
end

%%  Generate the vector of bit reverse indices
% Mahesh Keerthivasan 2013
function dec_rev = getBitRevVec(etl)

if  etl ~= 2^ceil(log2(etl))
    error('bitrev:etl', 'ETL not a power of 2.Bit rev array does not exist')
end

dec = 0 : etl-1;
bin = de2bi(dec,'left-msb');
bin_rev = fliplr(bin);
dec_rev = bi2de(bin_rev,'left-msb');

end