#!/usr/bin/python3
import sys
import subprocess
import time
import glob
import os

print('Start Stub Managing Reboot Ansible Module Over Container')
boot_id_filepath = sys.argv[1]
keys_dirpath = sys.argv[2]

# Check that container is running
bashCommand = 'docker ps --filter name=rpi'
process = subprocess.run(bashCommand.split(), stdout=subprocess.PIPE,
                         universal_newlines=True)
if process.stdout.count("\n") != 2:
    print("RPI container is not running")
    exit(1)


print("Init Boot Id File")
boot_id = 0
with open(boot_id_filepath, 'w') as f:
    f.write(str(boot_id))

while True:
    # Wait that the container exit
    is_running = True
    while is_running:
        time.sleep(5)  # wait 5 sec.
        # Check if container is exited
        bashCommand = 'docker ps --all --filter name=rpi --filter exited=143'
        process = subprocess.run(bashCommand.split(), stdout=subprocess.PIPE,
                                 universal_newlines=True)
        is_running = process.stdout.count("\n") == 1

    print("RPI container is exited")
    # Do some action to simulate a new install made on the RPI
    print("Update boot id file")
    boot_id = boot_id + 1
    with open(boot_id_filepath, 'w') as f:
        f.write(str(boot_id))
    print("Remove SSH Host Key (fingerprint)")
    files = glob.glob("{}/*".format(keys_dirpath))
    for f in files:
        os.remove(f)

    time.sleep(1)
    print("ReStart the container")
    bashCommand = 'docker start rpi'
    process = subprocess.run(bashCommand.split(), stdout=subprocess.PIPE,
                             universal_newlines=True)
