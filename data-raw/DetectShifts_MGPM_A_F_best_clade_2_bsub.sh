mkdir -p Results/MGPM_A_F_best_clade_2_2
cd Results/MGPM_A_F_best_clade_2_2
if [ -f "FinalResult_MGPM_A_F_best_clade_2_2_.RData" ]
then
rm MPI*.log
rm CurrentResults*.RData
else
bsub -M 250000 -n 250 -W 23:59 -R ib sh R --vanilla --slave -f ../../DetectShifts_MGPM_A_F_best_clade_2.R
fi
cd ../..
