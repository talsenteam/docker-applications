import datetime
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')

now = datetime.datetime.now()
date = now.strftime('%Y-%m-%d')


def test_that_dojo_build_fails_with_error_code(host):
    r = host.run('dojo build')

    assert r.rc != 0


def test_that_dojo_build_logs_an_error_message(host):
    r = host.run('dojo build')

    assert r.stdout.startswith('Error: ')
