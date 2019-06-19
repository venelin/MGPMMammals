mkdir -p Results/MGPM_B_best_clade_2
cd Results/MGPM_B_best_clade_2
if [ -f "FinalResult_MGPM_B_best_clade_2.RData" ]
then
rm MPI*.log
rm CurrentResults*.RData
else
bsub -M 100000 -n 50 -W 23:59 -R ib sh R --vanilla --slave -f ../../DetectShifts_MGPM_B_best_clade_2.R
fi
cd ../..
