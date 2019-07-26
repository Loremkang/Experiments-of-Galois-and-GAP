import os

#walker = os.walk(".").file_list
files = os.listdir(".")

#for path, dir_list, file_list in files:
#    print(path, dir_list, file_list)

results = {}
sorted_result = []
for fileName in files:
    #print(fileName)
    configures = (fileName.split('.'))
    if (configures[0] != "gap"):
        continue
    #threadNum = configures[-2]
    problem = configures[1]
    graphName = str.join(".", configures[2:-2])
    #print(graphName)

    time = -1
    file = open(fileName)
    for line in file:
        info = line.split(' ')
        if (info[0] == "Average" and info[1] == "Time:"):
            #results[(graphName, problem)] = info[-1]
            sorted_result.append((graphName, problem, info[-1].replace('\n', "")))
            break
    #break

sorted_result.sort()

for result in sorted_result:
    print("%-70s%-20s%-20s" % tuple(result))
