pkg load statistics
warning ("off");
t0 = clock ();

qtd_itr=50000
qtt_outs_min = 0
qtt_outs_max = 2
alias_aux = {'networkA','networkB','networkC','networkD','networkE','networkF'};
for alias_num = 1:length(alias_aux)
   for min_err = [3, 6]

    mfilename ()
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3


rand("state",[13]);randn("state",[13]);

[A, dp, MVC, P, U, m, n] = get_network(alias);

[obs_errors, outs_positions] = gera_smc(MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);


if qtt_outs_max != 0
filename=sprintf("%s_outs_positions_%d-%douts_%d-%ds_%ditr_train", alias,...
qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "outs_positions");
end
tempo = etime (clock (), t0)/60

endfor endfor
