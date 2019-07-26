#!/bin/bash

# called by run_experiments.sh

PARALLEL_CONVERT=$1

GALOIS_GRAPH_CONVERTER=$2
GAP_GRAPH_CONVERTER=$3

SRC_GRAPH_FOLDER=$4
DST_GRAPH_FOLDER=$5

unweighted_graphs=(
soc-LiveJournal1_sym.adj
com-orkut.ungraph.adj
twitter_sym.adj
friendster_sym.adj
)

int32_weighted_graphs=(
soc-LiveJournal1_sym_wgh.adj
com-orkut.ungraph_wgh.adj
twitter_sym_wgh.adj
friendster_sym_wgh.adj
)

function convert_graph() { 
	src_graph=$1
	galois_dst_graph=${src_graph%.adj}.gr
	el_dst_graph=${src_graph%.adj}.el
	gap_dst_graph=${src_graph%.adj}.sg
	wflag=
	if [ $2 == "-edgeType=int32" ]; then
		el_dst_graph=${src_graph%.adj}.wel
		gap_dst_graph=${src_graph%.adj}.wsg
		wflag="-w"
	fi

	echo "converting ${src_graph} to ${galois_dst_graph}"
	if [ ! -f ${DST_GRAPH_FOLDER}/${galois_dst_graph} ]; then
		${GALOIS_GRAPH_CONVERTER} -pbbs2gr $2 ${SRC_GRAPH_FOLDER}/${src_graph} ${DST_GRAPH_FOLDER}/${galois_dst_graph}
	else
		echo "${galois_dst_graph} exists"
	fi
	
	if [ -f ${DST_GRAPH_FOLDER}/${gap_dst_graph} ]; then
		echo "${gap_dst_graph} exists"
		return 0
	fi

	echo "converting ${galois_dst_graph} to ${el_dst_graph}"
	if [ ! -f ${DST_GRAPH_FOLDER}/${el_dst_graph} ]; then
		${GALOIS_GRAPH_CONVERTER} -gr2edgelist $2 ${DST_GRAPH_FOLDER}/${galois_dst_graph} ${DST_GRAPH_FOLDER}/${el_dst_graph}
	else
		echo "${el_dst_graph} exists"
	fi

	echo "converting ${el_dst_graph} to ${gap_dst_graph}"
	if [ ! -f ${DST_GRAPH_FOLDER}/${gap_dst_graph} ]; then
		${GAP_GRAPH_CONVERTER} -s ${wflag} -f ${DST_GRAPH_FOLDER}/${el_dst_graph} -b ${DST_GRAPH_FOLDER}/${gap_dst_graph}
	else
		echo "${gap_dst_graph} exists"
	fi

	rm ${DST_GRAPH_FOLDER}/${el_dst_graph}
}


if [ ${PARALLEL_CONVERT} == "true" ]; then
	echo "Start Converting Unweighted Graphs"
	for src_graph in ${unweighted_graphs[@]}
	do
		convert_graph ${src_graph} -edgeType=void &
	done

	echo "Start Converting Weighted Graphs"
	for src_graph in ${int32_weighted_graphs[@]}
	do
		convert_graph ${src_graph} -edgeType=int32 &
	done	
else
	echo "Start Converting Unweighted Graphs"
	for src_graph in ${unweighted_graphs[@]}
	do
		convert_graph ${src_graph} -edgeType=void
	done

	echo "Start Converting Weighted Graphs"
	for src_graph in ${int32_weighted_graphs[@]}
	do
		convert_graph ${src_graph} -edgeType=int32
	done
fi

wait