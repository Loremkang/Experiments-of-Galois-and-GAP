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
    configures = configures[1:]
    if (configures[0] != "parallel" and configures[0] != "serial"):
        continue
    threadNum = configures[-3]
    tid = configures[-2]
    algo = ""
    if (configures[-4].find('-algo=') != -1):
        algo = configures[-4][6:] 
    else:
        algo = ""
    par = configures[0]
    problem = configures[1]
    graphName = str.join(".", configures[2:-4])
    #print(graphName)

    time = -1
    file = open(fileName)
    for line in file:
        info = line.split(', ')
        if (info[0] == "STAT" and info[1] == "(NULL)" and info[2] == "Time" and info[3] == "TMAX"):
            time = int(info[-1])
            break
    
    assert(time != -1)

    if (not (graphName, problem, algo) in results):
        tmp = {}
        tmp['serial'] = []
        tmp['parallel-1'] = []
        tmp['parallel-n'] = []
        results[(graphName, problem, algo)] = tmp
    if (par == "serial"):
        results[(graphName, problem, algo)]['serial'].append(time)
    elif (par == "parallel" and threadNum == "1"):
        results[(graphName, problem, algo)]['parallel-1'].append(time)
    elif (par == "parallel" and threadNum != "1"):
        results[(graphName, problem, algo)]['parallel-n'].append(time)
    #break

for (key) in results:
    #print(key, (results[key]))
    setting = key
    time = results[setting]
    serial_time = -1
    parallel_time = -1
    if (len(time['serial']) > 0):
        serial_time = sum(time['serial']) / len(time['serial'])
    elif(len(time['parallel-1']) > 0):
        serial_time = sum(time['parallel-1']) / len(time['parallel-1'])
    
    if (len(time['parallel-n']) > 0):
        parallel_time = sum(time['parallel-n']) / len(time['parallel-n'])
        # parallel algorithm

    accelerate_rate = -1
    if (serial_time > 0 and parallel_time > 0):
        accelerate_rate = serial_time / parallel_time
    
    sorted_result.append([str(setting), str(serial_time), str(parallel_time), str(accelerate_rate), str(time['serial']), str(time['parallel-1']), time['parallel-n']])
    #pass

sorted_result.sort()

print("%-70s%-20s%-20s%-20s%-40s%-40s%-40s" % ("setting", "serial time", "parallel time", "accelerate rate", "serial result", "parallel-1thread result", "parallel-nthread result"))

for result in sorted_result:
    print("%-70s%-20s%-20s%-20s%-40s%-40s%-40s" % tuple(result))