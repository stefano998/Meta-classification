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
   for min_err = [3, 6]

    mfilename ()
    pesos = pesos_aux{pesos_num}
    alias = alias_aux{alias_num}
    min_err
    max_err = min_err + 3


[A, dp, MVC, P, U, m, n] = get_network(alias);

rand("state",[14]);randn("state",[14]);

[obs_errors, outs_positions] = gera_smc_0outdif(qtd_0out,MVC, dp, m, qtd_itr, qtt_outs_min, qtt_outs_max, min_err, max_err);

Ev=inv(P)-A/(A'*P*A)*A';

I = eye(m);
R=I-A/(A'*P*A)*A'*P;
vAll= R*obs_errors';
Pv=P*vAll; PEvP=sqrt(diag(P*Ev*P)); wAll=abs(Pv./(PEvP+0.00000000000001));
wAll=wAll';

size(wAll)
filename=sprintf("%s_wAllIDS_%s_0out%d_%d-%douts_%d-%ds_%ditr", alias,...
pesos, qtd_0out, qtt_outs_min, qtt_outs_max, min_err, max_err, qtd_itr);
save ("-ascii", filename, "wAll");

ww=abs(wAll(1:qtd_0out,:));
vetorMax_ww=max(ww');
vetorMax_ww=sort(vetorMax_ww);

VC=[];
alpha = 0.05;
for alfa = [0.001, 0.0027, 0.005,0.01, 0.025, 0.05, 0.10, alpha]
  Posicao_corte=round((qtd_0out)*(1-alfa));
  Valor_corte=vetorMax_ww(Posicao_corte);
  VC=[VC; alfa Valor_corte];
end

VC
filename=sprintf("VC_IDS_%s_%s_%d", pesos, alias, qtd_0out);
save ("-ascii", filename, "VC");

tempo = etime (clock (), t0)/60

endfor endfor endfor
