pkg load statistics
warning ("off");
t0 = clock ();

qtd_0out = 200000
qtd_itr=50000
qtt_outs_min = 1
qtt_outs_max = 2
pesos_aux = {'pp'};
alias_aux = {'networkA'};
for alias_num = 1:length(alias_aux)
  for pesos_num = 1:length(pesos_aux)
   for min_err = [6]

    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3
    WIDS = 0;

filename=sprintf("VC_IDS_%s_%s_%d", pesos, alias, qtd_0out);
VCAll=importdata(filename);
alpha=VCAll(8,1)
WIDS=VCAll(8,2)

rand("state",[14]);randn("state",[14]);

[A, dp, MVC, P, U, m, n] = get_network(alias);
Ev_A=inv(P)-A/(A'*P*A)*A';

[obs_errors, outs_positions] = gera_smc_0outdif(qtd_0out,MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

y_val = outs_positions;

invP=inv(P);
y_pred = zeros(rows(y_val),m);
for i = 1:rows(y_val)
  i;
A1=A; P1=P; invP1=invP; m1=m;
y_pred(i,:) = functionIDS(m1,A1,P1,invP1,obs_errors(i,:)',WIDS); end


[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

filename=sprintf("%s_ypredIDS_%s_0out%d_%d-%douts_%d-%ds_%ditr", alias,...
pesos, qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
filename=sprintf("acc_IDS_%s_%s_0out%d_%d-%douts_%d-%ds_%d_alpha%d", pesos, alias,...
qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc");


tempo = etime (clock (), t0)/60

endfor endfor endfor
