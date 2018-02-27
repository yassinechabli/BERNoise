%-----Calcul du TEB en fonction du bruit------------

clc; clear; close all;
%Paramètres de simulation
EbN0 = 0 : 7; %Rapport signal sur bruit a echelle binaire
Nb = 10000; %Nbre de données binaires
Niter = 5; % Nbre d'itérations

for k =1 : length(EbN0)
    
    Nerr = 0; %initialistation du nbre d'erreurs 
    for i=1 : Niter
        data_tx = rand(1,Nb) > 0.5;

    %-----Mapping bipolaire-----
        sym_tx = 2*data_tx -1;

    %-----Ajout du bruit blanc gaussien----------
        sig_rx = awgn(complex(sym_tx), EbN0(k), 'measured');

    %-----Decision---------
        sym_rx = sign(sig_rx);

    %------Demapping---------
        data_rx = sym_rx > 0;

    %-------Comparaison des data-----------
        vec_err = xor(data_rx, data_tx);

    %------Calcul du nombre d'erreur-----

    Nerr = Nerr + sum(vec_err);

    end
    
TEB(k) = Nerr / (Nb * Niter) ;
    
Pe = 0.5 * erfc(sqrt(10.^(EbN0/10)));
semilogy (EbN0(1:k) , TEB, 'rd-', EbN0, Pe, 'b--'); grid on;
pause(0.5); beep;

end

xlabel ('Eb/N0 (db)'); ylabel('TEB');
title  ('Calcul du TEB en fonction du Ebn0 pour une transmission bipolaire');
legend ('TEB calculé' , 'Probabilité théorique');

break


subplot(611); 
stem (data_tx); grid on; 
xlim([0 20]);
subplot(612);
stem (sym_tx); grid on; 
xlim([0 20]);
subplot(613);
stem (sig_rx); grid on; 
xlim([0 20]);
subplot(614);
stem (sym_rx); grid on; 
xlim([0 20]);
subplot(615);
stem (data_rx); grid on; 
xlim([0 20]);
subplot(616);
stem (vec_err); grid on; 
xlim([0 200]);


