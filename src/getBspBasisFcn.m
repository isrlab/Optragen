function BasisFcn = getBspBasisFcn(ninterv,ord,sm,HL)
n = 100*ninterv + 10*ord + sm;

[n,ii] = unique(n);
ninterv = ninterv(ii);
ord = ord(ii);
sm = sm(ii);

BasisFcn = sparse([]);

for i=1:length(ii)      
    knots = linspace(HL(1),HL(end),ninterv(i)+1);
    augknots = augknt(knots,ord(i),ord(i)-sm(i));
    BasisFcn = [BasisFcn spcol(augknots,ord(i),HL)];
end
