
ITERATIONS=$1
NUM_THREADS=$2
FORCE_REPLACE=$3

DST_GRAPH_FOLDER=$4
ALGORITHM_FOLDER=$5
RESULTS_FOLDER=$6

graphs=(
soc-LiveJournal1_sym.sg
com-orkut.ungraph.sg
twitter_sym.sg
friendster_sym.sg
soc-LiveJournal1_sym_wgh.wsg
com-orkut.ungraph_wgh.wsg
twitter_sym_wgh.wsg
friendster_sym_wgh.wsg
)

function run_algorithm() {
	graph=$1
	i=$2
	algo=$3
	shift 3;
	echo "${ALGORITHM_FOLDER}/${algo} -s -f ${DST_GRAPH_FOLDER}/${graph} $* -n ${ITERATIONS} > ${RESULTS_FOLDER}/gap.parallel.${algo}.${graph}.${NUM_THREADS}.${i}.txt "	
	if [[ ( ${FORCE_REPLACE} == "true" ) || ( ! -f "${RESULTS_FOLDER}/gap.parallel.${algo}.${graph}.${NUM_THREADS}.${i}.txt" ) ]]; then
		${ALGORITHM_FOLDER}/${algo} -s -f ${DST_GRAPH_FOLDER}/${graph} $* -n ${ITERATIONS} > ${RESULTS_FOLDER}/gap.parallel.${algo}.${graph}.${NUM_THREADS}.${i}.txt 
	else
		echo "Found"
	fi
}

function call_function() {
	for ((i=1;i<=1;i++));
	do
		for graph in ${graphs[@]}
		do
			run_algorithm ${graph} $i $*
		done
	done
}

echo "Start Running Algorithms"

if [ ! -d ${RESULTS_FOLDER} ]; then
	mkdir ${RESULTS_FOLDER}
fi

call_function bc -r 10012 -a

call_function bfs -r 10012 -a

#call_function cc -r 10012 -a

#call_function cc_sv -r 10012 -a

call_function pr -r 10012 -a -i 100 -t 0.000001

call_function sssp -r 10012 -a

call_function tc -r 10012 -a 
