mkdir -p Results/SCALAROUOnPPCAData_best_clade
cd Results/SCALAROUOnPPCAData_best_clade
if [ -f "FinalResult_SCALAROUOnPPCAData_best_clade.RData" ]
then
rm MPI*.log
rm CurrentResults*.RData
else
bsub -M 100000 -n 50 -W 23:59 -R ib sh R --vanilla --slave -f ../../DetectShifts_SCALAROUOnPPCAData_best_clade.R
fi
cd ../..

