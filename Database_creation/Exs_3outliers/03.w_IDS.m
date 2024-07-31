pkg load statistics
warning ("off");
t0 = clock ();

qtd_itr=10000
qtt_outs_min = 0
qtt_outs_max = 3
pesos_aux = {'pp'};
alias_aux = {'networkA','networkB','networkC','networkD','networkE','networkF'};
for alias_num = 1:length(alias_aux)
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]

    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3


[A, dp, MVC, P, U, m, n] = get_network(alias);

rand("state",[54]);randn("state",[54]);

[obs_errors, outs_positions] = gera_smc_3outs(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

Ev=inv(P)-A/(A'*P*A)*A';


I = eye(m);
R=I-A/(A'*P*A)*A'*P;
vAll= R*obs_errors';
Pv=P*vAll; PEvP=sqrt(diag(P*Ev*P)); wAll=abs(Pv./(PEvP+0.00000000000001));
wAll=wAll';

filename=sprintf("%s_wAllIDS_%s_%d-%douts_%d-%ds_%ditr", alias,...
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "wAll");

tempo = etime (clock (), t0)/60

endfor endfor endfor
