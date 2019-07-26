# Experiments Setup For Galois & GAP

By Hongbo Kang, July 25th 2019 at CMU

## This experiment pack provide

The core running time of Galois & GAP's implementation of several important algorithms, which work best on sparce and low diameter graph.

## This experiment pack require

1. Graphs represented in PBBS format.
2. Source file of Galois & GAP (I change some file to run the test. So try no to modify the directory structure).
3. Python 2/3

## Space requirement

2 * (total space of all graph) is needed at least (130GB), additional storage needed when converting the graph, all needed storage add up to 180GB at most, since it's believed that we'll have enough storage on the test environment.

## How to Use

1. get source code of Galois and Gap.
2. modify `run_experiments.sh` for file address setup.
3. modify `convert_graphs.sh` to included needed graphs(they should be in the src folder of `run_experiments.sh`).
4. run `run_experiments.sh`

(the script will do the following things)

1. replace some file of Galois. (TC and graph-convert, default no)
2. use make to compile Galois and GAP. (default no)
3. use the converter of Galois to convert PBBS graph to Galois graph.
4. use converters of Galois & GAP to convert Galois graph to edgelist, then to GAP format.
5. pick out mentioned algorithms from Galois & GAP.
6. run the algorithms in their fastest setting according to our previous experiments.
7. use Python script to generate the result

## Configurations

See comments in the file

## Implementation details that may cause problems

Modify run_experiments.sh to change follows:

1. The script automatically check if a result file is already generated before running experiments. If so, they will pass the experiment. 
2. The graph conversion takes lots of time and space. They're serial by default, you can use parallel conversion, which may take more space to save intermediate results (edgelist representation). At most 1x more space.
3. shell display will be saved in "**_shell_display.txt"
