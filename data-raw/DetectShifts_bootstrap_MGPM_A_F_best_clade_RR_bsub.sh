for id in `seq 1 1 200`
do
mkdir -p Results_bootstrap/bootstrap_MGPM_A_F_best_clade_RR_id_$id
cd Results_bootstrap/bootstrap_MGPM_A_F_best_clade_RR_id_$id
if [ -f "FinalResult_bootstrap_MGPM_A_F_best_clade_RR_id_"$id".RData" ]
then
rm MPI*.log
rm CurrentResults*.RData
else
bsub -M 100000 -n 50 -W 23:59 -R ib sh R --vanilla --slave -f ../../DetectShifts_bootstrap_MGPM_A_F_best_clade_RR.R --args $id
fi
cd ../..
done
