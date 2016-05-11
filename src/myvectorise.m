function out = myvectorise(in)

out = regexprep(in,'/','./');
out = regexprep(out,'\*','.\*');
out = regexprep(out,'\^','.\^');
