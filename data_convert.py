import csv
import os

in_dir = '../src/2010/11/'
out_dir = '../src/'
# in_file = '../src/2007/11/20061105.txt'
out_file = '../src/201011.csv'

COLUMNS_COUNT = 24
ANSWER_INDEX = 17
IGNORE_COLUMNS = [14, 15, 16, ANSWER_INDEX, 18, 20, 22]

SERVICES = {
    'index': 1,
    'other': 1,
    'smtp': 2,
    'http': 3,
    'dns': 4,
    'ftp': 5,
    'ssl': 6,
    'ssh': 7,
    'ftp-data': 8,
    'smtp,ssl': 9,
    'teredo': 10,
    'dhcp': 11,
    'rdp': 12,
    'snmp': 13,
    'pop3': 14,
    'radius': 15,
    'sip': 16,
    'irc': 17,
    'http,irc': 14,
    'dns,sip': 15
}

PROTOCOLS = {
    'index': 23,
    'icmp': 1,
    'tcp': 2,
    'udp': 3
}

FLAGS = {
    'index': 13,
    'S0': 1,
    'S1': 2,
    'SF': 3,
    'REJ': 4,
    'S2': 5,
    'S3': 6,
    'RSTO': 7,
    'RSTR': 8,
    'RSTOS0': 9,
    'RSTRH': 10,
    'SH': 11,
    'SHR': 12,
    'OTH': 13
}


def read_txt(txt_file):
    res = []
    with open(txt_file) as file:
        reader = csv.reader(file, delimiter='\t')
        for row in reader:
            res.append(row)
    return res


def transform(data):
    res = []
    attack_labels = 0
    for row in data:
        row[FLAGS['index']] = FLAGS[row[FLAGS['index']]]
        row[SERVICES['index']] = SERVICES[row[SERVICES['index']]]
        row[PROTOCOLS['index']] = PROTOCOLS[row[PROTOCOLS['index']]]
        tmp = []
        for i in range(COLUMNS_COUNT):
            if i not in IGNORE_COLUMNS:
                tmp.append(row[i])
        tmp.append(row[ANSWER_INDEX])
        if row[ANSWER_INDEX] == '1':
            attack_labels += 1
        res.append(tmp)
    print(str(attack_labels / len(data) * 100) + " %")
    return res


def write_to_csv(csv_file, data):
    with open(csv_file, 'w', newline='') as file:
        writer = csv.writer(file, delimiter=';')
        for row in data:
            writer.writerow(row)


def union_files(src_dir, out):
    ls = [i for i in os.listdir(src_dir) if i.endswith('.txt')]
    with open(out, 'w') as f:
        for j in ls:
            s = open(src_dir + j).read()
            f.write(s)
            f.write('\n')


for filename in os.listdir(in_dir):
    print(filename)
    in_file = in_dir + filename
    out_file = out_dir + filename
    if filename in os.listdir(out_dir):
        continue
    raw_data = read_txt(in_file)
    transformed_data = transform(raw_data)
    write_to_csv(out_file, transformed_data)

# union_files(out_dir, out_dir + 'all.txt')
