import os
import pytest
import json

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.fixture()
def waited_failed_task_name(host):
    all_variables = host.ansible.get_variables()
    return all_variables['waited_failed_task_name']


@pytest.fixture()
def waited_failed_result_msg(host):
    all_variables = host.ansible.get_variables()
    return all_variables['waited_failed_result_msg']


@pytest.fixture()
def failure_info(host):
    all_variables = host.ansible.get_variables()
    json_file_path = "{}/failure_{}.json".format(
        os.environ['MOLECULE_EPHEMERAL_DIRECTORY'],
        all_variables['inventory_hostname']
    )
    with open(json_file_path) as json_file:
        data = json.load(json_file)
    return data


def test_failed_task_name(host, failure_info, waited_failed_task_name):
    assert failure_info['task_name'] == waited_failed_task_name


def test_failed_message(host, failure_info, waited_failed_result_msg):
    assert failure_info['return']['msg'] == waited_failed_result_msg
