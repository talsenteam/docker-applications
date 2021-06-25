import datetime
import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')

now = datetime.datetime.now()
date = now.strftime('%Y-%m-%d')


def test_that_workspace_template_is_set(host):
    f = host.file(f'/home/project/{date}-test/.workspace/.template')

    assert f.exists
    assert f.is_file
    assert f.content_string == f'c{os.linesep}'


@pytest.mark.parametrize('name', [
    'src/dummy.c',
    'src/dummy.h',
    'test/test_dummy.c',
    'project.yml',
])
def test_that_template_specific_file_is_existing(host, name):
    f = host.file(f'/home/project/{date}-test/{name}')

    assert f.exists
    assert f.is_file
    assert f.size > 0
