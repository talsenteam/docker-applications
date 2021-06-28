import datetime
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')

now = datetime.datetime.now()
date = now.strftime('%Y-%m-%d')


def test_that_dojo_rebuild_fails_with_error_code(host):
    r = host.run('dojo rebuild')

    assert r.rc != 0


def test_that_dojo_rebuild_logs_an_error_message(host):
    r = host.run('dojo rebuild')

    assert r.stdout.startswith('Error: ')
