import datetime
import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')

now = datetime.datetime.now()
date = now.strftime('%Y-%m-%d')
workspace_dir = f'/home/project/{date}-test'


@pytest.mark.parametrize('name', [
    f'{workspace_dir}/build',
])
def test_that_directory_exists(host, name):
    d = host.file(name)

    assert d.exists
    assert d.is_directory
