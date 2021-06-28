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
    'target/classes',
    'target/test-classes',
])
def test_that_workspace_directory_exists(host, name):
    d = host.file(f'{workspace_dir}/{name}')

    assert d.exists
    assert d.is_directory


@pytest.mark.parametrize('name', [
    'target',
])
def test_that_build_directory_has_been_replaced(host, name):
    f = host.file(f'{workspace_dir}/{name}/.marker')

    assert not f.exists
