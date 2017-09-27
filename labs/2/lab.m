%% Gwen Lofman
% ISC4221 Lab 2: protein distributions
%%
%% randprotein
% Generating random proteins was an interesting exercise; in principle it's
% just a random integer generator where instead of returning the numbers
% 1-4 we map these values to character values.  Since MATLAB has extremely
% flexible indexing rules, if we have a character vector with all of the
% possible characters, we can just provide a matrix of any size, as long as
% it's values are all $x_i\epsilon[1,4]$ then it will simply treat them as
% indecies and build a matrix with the indexed values in place of the
% indecies.
%
%   a = 'acgt';
%   a(randi(numel(a), 10, 1)) % index into `a` with random integers
%
%   ans =
%
%      'cgggcaccct'
%
% Using this approach it was very easy to implement the 'randprotein'
% function.  It would perform faster if i didn't have to eliminate stop
% codons, I wish I could do inline if expressions but matlab does not
% provide a facility to do this, so instead I have to index through the
% whole character vector once I've made it and replace the stop codons that
% I identified.
%
%% countacids
% I wanted to have the same approximate api as the intrinsic strcmp
% function where if I want to count multiple acids I can just provide a
% cell array of the ones I want to count.
%
% In principle it operates much the same way as randprotien, using MATLAB's
% flexible indexing rules to do all of the work.  I first compared each
% codon to all of the codons in the map to build up a distribution of all
% the codons in the protein; this way, I don't have to do extra work if I
% ever want to count multiple acids.
%
% Once I buld the distribution of all codons, I idnetify the range of
% indecies where each codon matches the target amino acid, and index into
% the array and sum the values from the distribution to get a total count,
% doing this once for each amino acid I need to search.
%
%   dist = dist + strcmp(p(3*n-2:3*n), acids(:,2));
%
% This line does all of the work building up the distribution; first I
% compare the character matrix stored in the acid map to each codon in the
% protein.  strcmp returns a vector of logical values the same size as the
% cell array of acids.  This means I can just perform a summation of this
% over the protein (grouped by codons) and build up the full distribution
% of codons.
%
%   n(i) = sum(dist(strcmp(A(i), acids(:,1))));
%
% The same principle applies when I want to calcualte my results; I just
% find the range in the acids cell array which corresponds to each amino
% acid in my input cell array, and find the sum of the values from the
% distribution.
%
% This allows for an extremely flexile and fault tolerant implementation,
% at least once i've properly handled and processed the input.