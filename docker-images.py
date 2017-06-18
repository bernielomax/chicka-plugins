#!/usr/bin/python

import docker
import json
import argparse

parser = argparse.ArgumentParser(description='Threshold.')
parser.add_argument('--threshold', type=int, default=5, help='fail if the image count is greater than the threshold')
args = parser.parse_args()

client = docker.from_env()

count = 0

for image in client.images.list():
    count += 1

result = True

if count > args.threshold:
    result = False


result = {'result': result, 'data': count, 'expect': True, 'description': "the total number of docker images must not exceed %d" %(args.threshold)}

print json.dumps(result)
