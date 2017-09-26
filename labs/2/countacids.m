function [ n ] = countacids( p, A )
%COUNTACIDS count the instances of the specified acid in the given protein
%
%   n = COUNTACIDS(p,a) returns the number of instances n of amino acid a
%   in protein p
%   - if a is a single character, it is the single-letter-code (SLC) for
%     the given amino acid. (Note: Stop codons are identified by 'X'.)
%   - if a character array, it is the full name of the protein
%
%   N = COUNTACIDS(p,A) where A is a cell array of amino acid names or SLCs
%   will return vector N with the count of each amino acid.
%
%   Examples:
%
%   Count all of the appearances of Leucine in a random protein with 40
%   codons using Lecine's single letter code.
%
%       COUNTACIDS(randprotein(40), 'L')
%
%   Count all of the appearances of glutamic acid in a random protien using
%   it's SLC and count all appareances of aspartic acid using it's name.
%
%       COUNTACIDS(randprotein(40), {'E', 'aspartic acid'});
%
%   See also RANDPROTEIN, SUM

if mod(numel(p),3) ~= 0, error('invalid protein size %d', numel(p)); end

% Map single letter codes (SLCs) to Full protein names
SLC={'isoleucine','I';
     'leucine','L';
     'valine','V';
     'phenylalanine','F';
     'methionine','M';
     'cysteine','C';
     'alanine','A';
     'glycine','G';
     'proline','P';
     'threonine','T';
     'serine','S';
     'tyrosine','Y';
     'tryptophan','W';
     'glutamine','Q';
     'asparagine','N';
     'histidine','H';
     'glutamic acid','E';
     'aspartic acid','D';
     'lysine','K';
     'arginine','R';
     'stop codons','X';
     };

% Define lambda function to convert acid name to a single letter code
name2slc = @(name) cell2mat(SLC(strcmp(name,SLC(:,1)),2));

% Convert amino acid name to single letter code 
if ~isscalar(A) && ~iscell(A), A=name2slc(A); end

% Handle each cell array input, converting names to SLCs along the way
if iscell(A)
    for i=1:numel(A), if ~isscalar(A{i}), A{i}=name2slc(A(i)); end; end
    % Convert to a vector of SLCs for easier consumption
    A=cell2mat(A);
end

% Define a map which identifies which codons map to which proteins
acids={'I', 'att';'I', 'atc';'I', 'ata';
     'L','ctt';'L','ctc';'L','cta';'L','ctg';'L','tta';'L','ttg';
     'V','gtt';'V','gtc';'V','gta';'V','gtg';
     'F','ttt';'F','ttc';
     'M','atg';
     'C','tgt';'C','tgc';
     'A','gct';'A','gcc';'A','gca';'A','gcg';
     'G','ggt';'G','ggc';'G','gga';'G','ggg';
     'P','cct';'P','ccc';'P','cca';'P','ccg';
     'T','act';'T','acc';'T','aca';'T','acg';
     'S','tct';'S','tcc';'S','tca';'S','tcg';'S','agt';'S','agc';
     'Y','tat';'Y','tac';
     'W','tgg';
     'Q','caa';'Q','cag';
     'N','aat';'N','aac';
     'H','cat';'H','cac';
     'E','gaa';'E','gag';
     'D','gat';'D','gac';
     'K','aaa';'K','aag';
     'R','cgt';'R','cgc';'R','cga';'R','cgg';'R','aga';'R','agg';
     'X','taa';'X','tag';'X','tga'
     };

% Calculate codon distribution
dist = zeros(size(acids(:,2)));
for n=1:(numel(p)/3)
    dist = dist + strcmp(p(3*n-2:3*n), acids(:,2));
end

% From codon distribution, determine the mapping to amino acids
n = zeros(size(A));
for i=1:numel(A), n(i) = sum(dist(strcmp(A(i), acids(:,1)))); end

end
