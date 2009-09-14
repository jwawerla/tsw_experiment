function [new,inx] = shuffle(old)
%
% function [New, Inx] = shuffle(Old)
%
% takes the rows of a matrix Old and shuffles them at random,
% to produce a matrix New. (If Old is a row-vector, then so is New,
% being a random permutation of the elements of Old; so also is Inx).
%
% The vector Inx contains the random permutation of 1...n such that
% Old(Inx,:) = New.
%
  rand("uniform");
  [r,c] = size(old);
  if r==1, old=old'; is_row=1 ; else is_row=0; endif
  n = rows(old);
  q = rand(n,1);
  [p,inx] = sort(q); new = old(inx,:);
  if is_row, new=new'; inx=inx'; endif
endfunction 