% =======================================================================
%   OCP2NLP
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function Func = createMFunction(OutputSequence,Cin,tag,ProbName,ParamList)

if isa(Cin,'constraint')
    nlcIndex = findNonlinearConstraints(Cin);
    C = Cin(nlcIndex);
    typeCin = 'constraint';
else
    C = Cin;
    typeCin = 'cost';
end

switch tag
    case 'initial'
        switch typeCin
            case 'cost'
                funcName = ['function [f,df] = ' ProbName '_icf'];
            case 'constraint'
                funcName = ['function [f,df] = ' ProbName '_nlicf'];
        end
    case 'trajectory'
        switch typeCin
            case 'cost'
                funcName = ['function [f,df] = ' ProbName '_tcf'];
            case 'constraint'
                funcName = ['function [f,df] = ' ProbName '_nltcf'];
        end
    case  'final'
        switch typeCin
            case 'cost'
                funcName = ['function [f,df] = ' ProbName '_fcf'];
            case 'constraint'
                funcName = ['function [f,df] = ' ProbName '_nlfcf'];
        end
    case  'galerkin'
        switch typeCin % Only constraints can have Gelarkins
            case 'constraint'
                funcName = ['function [f,df] = ' ProbName '_nlgcf'];
        end
    otherwise
        error('Illegal tag for constraint/cost');
end

argList = [createArgList(OutputSequence)];

Func = sprintf('%s(%s)',funcName,argList);
fBlock = 'f = []; '; % Don't make them empty using [], it causes problems
dfBlock = 'df = []; ';% Don't make them empty using [], it causes problems

funcCount = 1;

for i=1:length(C)
    Type = get(C(i),'type');
    c = get(C(i),'func');
    if strcmp(Type,tag)
        if ischar(c.func)
            fBlock = [fBlock sprintf('\t f(%d,:) = %s;\n',funcCount,myvectorise(c.func));];
            for j = 1:length(OutputSequence)
                I = strcmp(OutputSequence{j},c.Tnames);
                if sum(I) == 0
                    GRAD = sprintf('zeros(size(%s))',OutputSequence{j}); % For vectorization purposes
                else
                    gIndex = find(I==1);
                    if size(gIndex) ~= [1 1];
                        error('gIndex is non scalar => more than one trajectories found');
                    end
                    GRAD = c.grad{gIndex};
                    if isempty(symvar(GRAD))
                        GRAD = sprintf('%s*ones(size(%s))',GRAD,OutputSequence{j}); % For vectorization purposes.
                    end
                end
                switch typeCin
                    case 'cost';
                        dfBlock = [dfBlock sprintf('\t df(%d,:)= %s; \n',j,myvectorise(GRAD));];
                    case 'constraint'
                        dfBlock = [dfBlock sprintf('\t df(%d,%d,:) = %s; \n',j,funcCount,myvectorise(GRAD));];
                end
            end % for j
            funcCount = funcCount + 1;
        end % if ischar
    end %if strcmp
end % for i

if ~isempty(ParamList)
    glbVar = ['global ' sprintf('%s ',ParamList{:})];
else
    glbVar = ' ';
end
Func = sprintf('%s\n%s\n%s\n%s\n',Func,glbVar,fBlock,dfBlock);