pkg load statistics
warning ("off");
t0 = clock ();

qtd_0out = 200000
qtd_itr=50000
qtt_outs_min = 1
qtt_outs_max = 2
pesos_aux = {'pp'};
alias_aux = {'networkA','networkB','networkC','networkD','networkE','networkF'};
for alias_num = 1:length(alias_aux)
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3,6]

    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3


rand("state",[14]);randn("state",[14]);

[A, dp, MVC, P, U, m, n] = get_network(alias);

[obs_errors, outs_positions] = gera_smc_0outdif(qtd_0out, MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

P = diag(1./diag(MVC));
if pesos == "pr"
  P = chol(P); end
if pesos == "pi"
  P = eye(m); end

I = eye(m);
O = zeros(m,2*n);
A1 = [A -A -I I zeros(m,1)];
A2 = [O P -P (-1)*ones(m,1)];
A3 = [O -P P (-1)*ones(m,1)];
A = cat(1,A1, A2, A3);
c=zeros(1,2*(n+m)+1);c(1,2*(n+m)+1)=1;
ctype1 = repmat("S",1,m);
ctype2 = repmat("U",1,2*m);
ctype = cat(2,ctype1,ctype2);
vartype = repmat("C",1,2*(n+m)+1);

vAll = [];

for q=1:rows(obs_errors)
e=cat(1,obs_errors(q,:)',zeros(2*m,1));
[xopt, fopt, erro, extra] = glpk (c, A, e, lb=[], ub=[], ctype, vartype);
v = xopt(2*n+1:2*n+m) - xopt(2*n+m+1:2*n+2*m);
vAll=[vAll; v'];
end

filename=sprintf("%s_vAll_LInf_%s_0out%d_%d-%douts_%d-%ds_%ditr", alias,...
pesos, qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "vAll");
tempo = etime (clock (), t0)/60

endfor endfor endfor
