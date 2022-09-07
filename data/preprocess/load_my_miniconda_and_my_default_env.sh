
set -x

# abandon any existing PYTHONPATH (recommended, if you want to use miniconda or anaconda)
unset PYTHONPATH

# activate my default conda env (miniconda was widely installed by Oliver)
#~ conda activate pcrglobwb_python3
conda activate pcrglobwb_python3_2022-04-22

# use at least 8 workers
export PCRASTER_NR_WORKER_THREADS=8


set +x

