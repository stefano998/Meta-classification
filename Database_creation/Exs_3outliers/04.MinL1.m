pkg load statistics
warning ("off");
t0 = clock ();

qtd_itr=10000
qtt_outs_min = 0
qtt_outs_max = 3
pesos_aux = {'pi'};
alias_aux = {'networkA','networkB','networkC','networkD','networkE','networkF'};
test_stat_aux = {'sigma_v'};
for alias_num = 1:length(alias_aux)
 for test_stat_num = 1:length(test_stat_aux)
  for pesos_num = 1:length(pesos_aux)
   for min_err = [3, 6]

    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    test_stat = test_stat_aux{test_stat_num}
    min_err
    max_err = min_err + 3
    WL1 = 0;

filename=sprintf("VC_L1_%s_%s_%s_%d", pesos, alias, test_stat, 200000);
VCAll=importdata(filename);
alpha=VCAll(8,1)
WL1=VCAll(8,2)


[A, dp, MVC, P, U, m, n] = get_network(alias);

filename=sprintf("Ev_SMC_L1_%s_%s_%ditr", pesos, alias, 200000);
Ev_SMC=importdata(filename);
DPvv=(sqrt(diag(Ev_SMC)))';

filename=sprintf("%s_vAll_L1_%s_%d-%douts_%d-%ds_%ditr", alias,...
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
vAll=importdata(filename);

if qtt_outs_max != 0
filename=sprintf("%s_outs_positions_%d-%douts_%d-%ds_%ditr", alias,...
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
y_val=importdata(filename);
else y_val=zeros(qtd_itr,m); endif

if test_stat == "sigma_v"
  y_pred = abs(vAll./DPvv) > WL1;
  else y_pred = abs(vAll./dp) > WL1;end

[acc, y_pred_acertou] = acc_score_3outs(y_pred,y_val);
acc


filename=sprintf("%s_ypredEL1_%s_%s_%d-%douts_%d-%ds_%ditr", alias,...
pesos, test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "y_pred");
filename=sprintf("acc_EL1_%s_%s_%s_%d-%douts_%d-%ds_%d_alpha%d", pesos, alias,...
test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr, alpha*100);
save ("-ascii", filename, "acc");


tempo = etime (clock (), t0)/60



endfor endfor endfor endfor
