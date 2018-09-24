function string = strxcat(varargin)

% A variable number of strings or numbers are concatenated into the output string.
%
% INPUT : n strings or numbers
% OUTPUT: string

string = [];
nbarg = length(varargin);
if nbarg == 0
return
end

for arg_i = 1:nbarg
substr = varargin{arg_i}(:)';
string = [string num2str(substr)];
end


%qUELLE:
%AM 4.6.2014
%http://etools.fernuni.ch/matlab/matlab3/de/html/mfiles_learningObject5.html#_vararg.html
%http://etools.fernuni.ch/matlab/matlab3/de/html/strings_learningObject1.html