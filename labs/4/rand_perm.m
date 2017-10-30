function p = rand_perm ( n )
%RAND_PERM returns a random permutation of integers 1 to N
p = 1 : n;

for i = 1 : n - 1
    j = randi([i n],1);

    t = p(j);
    p(j) = p(i);
    p(i) = t;
end

end

