#! /bin/bash


## config
# process control
CODE_REPLACE=true
MAKE=true


# thread number
NUM_THREAD=32
ITERATIONS=1
FORCE_REPLACE=true # or true
PARALLEL_CONVERT=false # or true

# code
CODE_SRC=../rewrite_code

# source file of galois and gap. try no to modify since implementation of graph_convert & triangle counting modified
GALOIS_SRC=../../Galois
GAP_SRC=../../gapbs

# folder to save the results
GALOIS_RESULT=../galois_result
GAP_RESULT=../gap_result

# folder to save converted graph
GRAPH_SRC=/ssd1/graphs/bench_experiments
GRAPH_DST=/ssd0/galois_graphs

# folder to save implementations
GALOIS_IMP=../galois_imp
GAP_IMP=../gap_imp


## variables
cur_dir="$(pwd)"
galois_imp_src=${GALOIS_SRC}/lonestar/
galois_graph_converter=${GALOIS_SRC}/tools/graph-convert/graph-convert
gap_graph_converter=${GAP_SRC}/converter


## process

# replace files
if [ ${CODE_REPLACE} == "true" ]; then
    mv -f ${CODE_SRC}/graph-convert.cpp ${GALOIS_SRC}/tools/graph-convert/graph-convert.cpp
    mv -f ${CODE_SRC}/Triangles.cpp ${GALOIS_SRC}/lonestar/triangles/Triangles.cpp
fi

# build galois & gap
if [ ${MAKE} == "true" ]; then
    cd ${GALOIS_SRC}
    cmake .
    make -j
    cd ${cur_dir}

    cd ${GAP_SRC}
    make -j
    cd ${cur_dir}
fi

# grip algorithms
if [ ${FORCE_REPLACE} == "true" ]; then
    rm -r ${GALOIS_IMP}
    rm -r ${GAP_IMP}
fi

if [ ! -d ${GALOIS_IMP} ]; then
	mkdir ${GALOIS_IMP}
fi

if [ ! -d ${GAP_IMP} ]; then
	mkdir ${GAP_IMP}
fi

cp ${galois_imp_src}/bfs/bfs ${GALOIS_IMP}/bfs
cp ${galois_imp_src}/betweennesscentrality/bc-level ${GALOIS_IMP}/bc-level
cp ${galois_imp_src}/boruvka/boruvka ${GALOIS_IMP}/boruvka
cp ${galois_imp_src}/independentset/independentset ${GALOIS_IMP}/independentset
cp ${galois_imp_src}/kcore/kcore ${GALOIS_IMP}/kcore
cp ${galois_imp_src}/pagerank/pagerank-pull ${GALOIS_IMP}/pagerank-pull
cp ${galois_imp_src}/sssp/sssp ${GALOIS_IMP}/sssp
cp ${galois_imp_src}/triangles/triangles ${GALOIS_IMP}/triangles

cp ${GAP_SRC}/bc  ${GAP_IMP}/bc
cp ${GAP_SRC}/bfs  ${GAP_IMP}/bfs
#cp ${GAP_SRC}/cc  ${GAP_IMP}
cp ${GAP_SRC}/pr  ${GAP_IMP}/pr
cp ${GAP_SRC}/sssp  ${GAP_IMP}/sssp
cp ${GAP_SRC}/tc  ${GAP_IMP}/tc


# convert graph
bash convert_graphs.sh ${PARALLEL_CONVERT} ${galois_graph_converter} ${gap_graph_converter} ${GRAPH_SRC} ${GRAPH_DST}

# run galois experiments
galois_display=galois_shell_display.txt
while [ -f ${galois_display} ]; do
    galois_display=${galois_display%.txt}.ap.txt
done
bash run_algorithms_galois.sh ${ITERATIONS} ${NUM_THREAD} ${FORCE_REPLACE} ${GRAPH_DST} ${GALOIS_IMP} ${GALOIS_RESULT} | tee ${galois_display}

# run gap experiments
gap_display=gap_shell_display.txt
while [ -f ${gap_display} ]; do
    gap_display=${gap_display%.txt}.ap.txt
done
bash run_algorithms_gap.sh ${ITERATIONS} ${NUM_THREAD} ${FORCE_REPLACE} ${GRAPH_DST} ${GAP_IMP} ${GAP_RESULT} | tee ${gap_display}

# analyse result
cp galois_analyser.py ${GALOIS_RESULT}
cd ${GALOIS_RESULT}
python galois_analyser.py > galois_result.txt
cd ${cur_dir}

cp gap_analyser.py ${GAP_RESULT}
cd ${GAP_RESULT}
python gap_analyser.py > gap_result.txt
cd ${cur_dir}
