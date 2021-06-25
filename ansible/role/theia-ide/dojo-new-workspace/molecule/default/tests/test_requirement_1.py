import datetime
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')

now = datetime.datetime.now()
date = now.strftime('%Y-%m-%d')


def test_that_workspace_directory_exists(host):
    d = host.file(f'/home/project/{date}-test')

    assert d.exists
    assert d.is_directory


def test_that_workspace_name_is_set(host):
    f = host.file(f'/home/project/{date}-test/.workspace/.name')

    assert f.exists
    assert f.is_file
    assert f.content_string == f'test{os.linesep}'
