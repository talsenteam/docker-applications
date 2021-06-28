import datetime
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')

now = datetime.datetime.now()
date = now.strftime('%Y-%m-%d')


def test_that_workspace_directory_exists(host):
    d = host.file(f'/home/project/{date}-test/coverage')

    assert d.exists
    assert d.is_directory
