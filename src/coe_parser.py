import sys

file_name = sys.argv[1]

with open(file_name, 'r') as f:
    copy_file_name = 'coe.mem'
    with open(copy_file_name, 'w') as cf:
        line_cnt = 0
        for line in f:
            for line_index in range(len(line)):
                if (line_cnt == 5):
                    cf.write(line[-6:-2])
                    cf.write('\n')
                    break
                elif (line_cnt > 5):
                    if line[line_index] != ',' and line[line_index] != ';':
                        cf.write(line[line_index])
            line_cnt = line_cnt + 1