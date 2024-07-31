pkg load statistics
warning ("off");
t0 = clock ();


qtd_itr=10000
qtt_outs_min = 0
qtt_outs_max = 3
pesos_aux = {'pp'};
alias_aux = {'networkA','networkB','networkC','networkD','networkE','networkF'};
test_stat_aux = {'sig_obs'};
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


[A, dp, MVC, P, U, m, n] = get_network(alias);


filename=sprintf("%s_vAll_LInf_%s_%d-%douts_%d-%ds_%ditr", alias,...
pesos, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
vAll=importdata(filename);


if test_stat == "sigma_v"
  wAll = abs(vAll./(DPvv+0.00000000001));
  else wAll = abs(vAll./dp);end


filename=sprintf("%s_wAllELInf_%s_%s_%d-%douts_%d-%ds_%ditr", alias,...
pesos, test_stat, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "wAll");

tempo = etime (clock (), t0)/60

endfor endfor endfor endfor
