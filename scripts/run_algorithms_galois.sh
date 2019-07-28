
ITERATIONS=$1
NUM_THREADS=$2
FORCE_REPLACE=$3

DST_GRAPH_FOLDER=$4
ALGORITHM_FOLDER=$5
RESULT_FOLDER=$6

graphs=(
soc-LiveJournal1_sym.gr
com-orkut.ungraph.gr
twitter_sym.gr
friendster_sym.gr
soc-LiveJournal1_sym_wgh.gr
com-orkut.ungraph_wgh.gr
twitter_sym_wgh.gr
friendster_sym_wgh.gr
)


# GRAPH ALGORIHTM ARGC
function run_serial() {
	graph=$1
	i=$2
	algo=$3
	shift 3;
	if [ $# > 0 ]; then
		implementation=${!#}
	else
		implementation=""
	fi
	rm -f ${DST_GRAPH_FOLDER}/*.triangles
	echo "${ALGORITHM_FOLDER}/${algo} -t=1 -statFile=${RESULT_FOLDER}/galois.serial.${algo}.${graph}.${implementation}.1.${i}.txt ${DST_GRAPH_FOLDER}/${graph} $*"
	if [[ ( ${FORCE_REPLACE} == "true" ) || ( ! -f "${RESULT_FOLDER}/galois.serial.${algo}.${graph}.${implementation}.1.${i}.txt" ) ]]; then
		${ALGORITHM_FOLDER}/${algo} -t=1 -statFile=${RESULT_FOLDER}/galois.serial.${algo}.${graph}.${implementation}.1.${i}.txt ${DST_GRAPH_FOLDER}/${graph} $*
		#echo "Skip"
	else
		echo "Found"
	fi
}

function run_algorithm() {
	graph=$1
	i=$2
	algo=$3
	shift 3;
	if [ $# > 0 ]; then
		implementation=${!#}
	else
		implementation=""
	fi
	rm -f ${DST_GRAPH_FOLDER}/*.triangles
	echo "${ALGORITHM_FOLDER}/${algo} -t=1 -/statFile=${RESULT_FOLDER}/galois.parallel.${algo}.${graph}.${implementation}.1.${i}.txt ${DST_GRAPH_FOLDER}/${graph} $*"	
	if [[ ( ${FORCE_REPLACE} == "true" ) || ( ! -f "${RESULT_FOLDER}/galois.parallel.${algo}.${graph}.${implementation}.1.${i}.txt" ) ]]; then
		${ALGORITHM_FOLDER}/${algo} -t=1 -statFile=${RESULT_FOLDER}/galois.parallel.${algo}.${graph}.${implementation}.1.${i}.txt ${DST_GRAPH_FOLDER}/${graph} $*
		#echo "Skip"
	else
		echo "Found"
	fi

	rm -f ${DST_GRAPH_FOLDER}/*.triangles
	echo "${ALGORITHM_FOLDER}/${algo} -t=${NUM_THREADS} -statFile=${RESULT_FOLDER}/galois.parallel.${algo}.${graph}.${implementation}.${NUM_THREADS}.${i}.txt ${DST_GRAPH_FOLDER}/${graph} $*"	
	if [[ ( ${FORCE_REPLACE} == "true" ) || ( ! -f "${RESULT_FOLDER}/galois.parallel.${algo}.${graph}.${implementation}.${NUM_THREADS}.${i}.txt" ) ]]; then
		${ALGORITHM_FOLDER}/${algo} -t=${NUM_THREADS} -statFile=${RESULT_FOLDER}/galois.parallel.${algo}.${graph}.${implementation}.${NUM_THREADS}.${i}.txt ${DST_GRAPH_FOLDER}/${graph} $*
	else
		echo "Found"
	fi
}

function call_function() {
	for ((i=1;i<=${ITERATIONS};i++));
	do
		for graph in ${graphs[@]}
		do
			run_algorithm ${graph} $i $*
		done
	done
}


function call_serial() {
	for ((i=1;i<=${ITERATIONS};i++));
	do
		for graph in ${graphs[@]}
		do
			run_serial ${graph} $i $*
		done
	done
}


echo "Start Running Algorithms"

if [ ! -d ${RESULT_FOLDER} ]; then
	mkdir ${RESULT_FOLDER}
fi

#call_function bc-async -numOfSources=1 -sourcesToUse=10012

##call_function betweennesscentrality-outer -startNode=10012
##not working.
##done
#
#call_serial bfs -startNode=10012 -exec=SERIAL -algo=AsyncTile 
#call_serial bfs -startNode=10012 -exec=SERIAL -algo=Async 
#call_serial bfs -startNode=10012 -exec=SERIAL -algo=Sync 
#call_serial bfs -startNode=10012 -exec=SERIAL -algo=Sync2pTile 
#call_serial bfs -startNode=10012 -exec=SERIAL -algo=Sync2p 
#
#call_function bfs -startNode=10012 -exec=PARALLEL -algo=AsyncTile 
#call_function bfs -startNode=10012 -exec=PARALLEL -algo=Async 
#call_function bfs -startNode=10012 -exec=PARALLEL -algo=Sync 
#call_function bfs -startNode=10012 -exec=PARALLEL -algo=Sync2pTile 
#call_function bfs -startNode=10012 -exec=PARALLEL -algo=Sync2p 
##done
#

#
#call_serial independentset -algo=serial
#call_function independentset -algo=pull
#call_function independentset -algo=nondet
#call_function independentset -algo=detBase
#call_function independentset -algo=prio
##done
#
#call_function kcore -kcore=100 -symmetricGraph -algo=Async
##done
#
#call_function pagerank-pull -tolerance=0.000001 -maxIterations=100 -algo=Residual
#call_function pagerank-push -tolerance=0.000001 -maxIterations=100 -algo=Async
#call_function pagerank-push -tolerance=0.000001 -maxIterations=100 -algo=Sync
##done
#
#
#call_function sssp -startNode=10012 -algo=deltaTile
#call_function sssp -startNode=10012 -algo=deltaStep
#call_function sssp -startNode=10012 -algo=serDeltaTile
#call_function sssp -startNode=10012 -algo=serDelta
#call_function sssp -startNode=10012 -algo=dijkstraTile
#call_function sssp -startNode=10012 -algo=dijkstra
#call_function sssp -startNode=10012 -algo=topoTile
##done
#
#call_function triangles -algo=nodeiterator
#call_function triangles -algo=edgeiterator
#call_function trianglesAOS
##done
#
##

#call_function bc-level -singleSource -startNode=10012

#call_serial bfs -startNode=10012 -exec=SERIAL -algo=SyncTile 

#call_function bfs -startNode=10012 -exec=PARALLEL -algo=SyncTile 

#call_function boruvka -symmetricGraph 

#call_function independentset -algo=edgetiledprio

#call_function kcore -kcore=100 -symmetricGraph -algo=Sync

#call_function pagerank-pull -tolerance=0.000001 -maxIterations=100 -algo=Topo

#call_function sssp -startNode=10012 -algo=topo

call_function triangles -algo=orderedCount