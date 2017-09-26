function [ p ] = randprotein( n )
%RANDPROTEIN generate a random protein with the desired number of codons
%
%   Will not generate a stop codon 'taa', 'tag' or 'tga' in the random
%   protein.
%
%   p = RANDPROTEIN(n) if n is a scalar generates a protein with n codons
%   p = RANDPROTEIN(N) if N is a vector generates a protein with as many
%   codons as elements of N
%
%   Examples:
%
%      Reset the random number generator used by randprotein to its default
%      startup settings, so that RANDPROTEIN produces the same random
%      numbers as if you restarted MATLAB.
%         rng('default')
%         RANDPROTEIN(5)
% 
%      Save the settings for the random number generator used RANDPROTEIN, 
%      generate a protein from RANDPROTEIN, restore the settings, and 
%      repeat those values.
%         s = rng;
%         p1 = RANDPROTEIN(5);
%         rng(s);
%         p2 = RANDPROTEIN(5); % contains exactly the same codons as p1
%         assert(all(p1==p2));
% 
%      Reinitialize the random number generator used by RANDPROTEIN with a
%      seed based on the current time.  RANDPROTEIN will return different
%      values each time you do this.  NOTE: It is usually not necessary to
%      do this more than once per MATLAB session.
%         rng('shuffle');
%         RANDPROTEIN(5)
%
%   See also rand, randi, randn, rng, sprand, sprandn, randperm

% Handle variadic arguments
if ~isscalar(n) && isvector(n), n=numel(n); end

% Define the set of amino acids such that indexing into acids will return
% one of the possible amino acids
acids = 'agct';

% Use the randi function to linearly index into the acids character array
% with a random number 1-4, with the number of indecies
codon = @(n) acids(randi(numel(acids),3*n,1));

p = codon(n);

% Search for and replace stop codons
for n=1:(numel(p)/3)
    while any(strcmp(p(3*n-2:3*n), {'taa','tag','tga'}))
        p(3*n-2:3*n) = codon(1);
    end
end

end
