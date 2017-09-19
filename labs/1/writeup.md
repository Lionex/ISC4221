# Lab 1

**Gwen Lofman**
_ISC4221_

# Problems 1 & 2

When I designed the API for my sort algorithms I had initially followed closely the API of matlab's intrisic `sort` function; I always try to think about how my functions and software will integrate with the greater ecosystem for a given programming language.  I want to make my code flexible for any end user.  MATLAB has a very flexible standard library of functions so my `bubble_sort` and `select_sort` functions initially copied the API of `sort` but with some twists; I allowed a custom ordering function so that it's easier for the user to define how to sort more complicated structures.  However, I realized that the problem might call for sorting a matrix of values, so I changed my sort functions to sort rows instead of sorting either the individual values of a vector, or the rows of a matrix as if they were vectors.

This was because the haversign distance formula required a latitude and longitude for datum, so I wanted to sort a lat-long matrix by it's rows, where each row represented a store location, and use the havedistance as my sorting critereon.

I also allowed returning a sort vecotr that would return the new indecies of the old values, so that I could do something like `A=rand(5,1); [B I]=select_sort(A); all(B==A(I))`, and have it evaluate to true.  This would allow me to index into the cell array of names and get the sorted (by distance) city names in problem 3.  I realized that this renderd changing the `bubble_sort` and `select_sort` APIs away from matlab's intrinisc sort function unecessary.

I wish I knew how to write proper unit tests in matlab, as it would make ensuring I would get a passing grade on the lab much easier.

# Problem 3

I wanted to have a vectorized `havedist` (haversine distance) formula.  It wasn't straightforward or necessary to follow the API of matlab's intrinisc distance formulas because they are all intended for data-mining applications and not more stragithforward tasks like simple data transformation.

In the end I realized that I did not need to change the `bubble_sort` and `select_sort` APIs to support using `havedist` inside the comparison operation.  I could have simply done the following:

```
L = deg2rad(cell2mat(T{2})); % latitude-longitude matrix
l = L(t); % latitude and longitude of the desired city
r_E = 3900; % radius of the earth in miles (sets the units of havedist)

[D I] = bubble_sort(havedist(L,ones(L).*l,r_E)); % transform and get sorted indicies

T = T{I}; % sort the city names in the sorted order that corresponds to distances D
```

This would probably be the much more natural way to do this in matlab, and would have allowed my sort functions to use the more natural API, but I would rather leave it as it is currently (it gives me more to write for the lab writeup).
