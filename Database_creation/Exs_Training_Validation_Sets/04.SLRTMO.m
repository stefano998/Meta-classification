pkg load statistics
warning ("off");
t0 = clock ();

qtd_itr=50000
qtt_outs_min = 0
qtt_outs_max = 2
qmax=qtt_outs_max+1;
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
    XSLRTMO = 0;

filename=sprintf("VC_SLRTMO_%s_%s_%d", pesos, alias, 200000);
VCAll=importdata(filename);
alpha=VCAll(8,1)
XSLRTMO=VCAll(8,2)

rand("state",[13]);randn("state",[13]);

[A, dp, MVC, P, U, m, n] = get_network(alias);
Ev_A=inv(P)-A/(A'*P*A)*A';
DPvv=(sqrt(diag(Ev_A)))';
dp;

[obs_errors, outs_positions] = gera_smc(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

y_val = outs_positions;

invP=inv(P);
y_pred = zeros(rows(y_val),m);

for i = 1:rows(y_val)
y_pred(i,:) = functionSLRTMO(m,A,P,invP,obs_errors(i,:)',XSLRTMO,qmax);
y_val(i,:); end

[acc, y_pred_acertou] = acc_score(y_pred,y_val);
acc

#test=columns(find(sum(y_pred')>2))################################

filename=sprintf("%s_ypredSLRTMO_%s_%d-%douts_%d-%ds_%ditr_train", alias,...
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
filename=sprintf("acc_SLRTMO_%s_%s_%d-%douts_%d-%ds_%d_alpha%d_train", pesos, alias,...
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc");

tempo = etime (clock (), t0)/60

endfor endfor endfor
