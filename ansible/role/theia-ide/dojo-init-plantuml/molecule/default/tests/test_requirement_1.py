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


def test_that_workspace_template_is_set(host):
    f = host.file(f'{workspace_dir}/.workspace/.template')

    assert f.exists
    assert f.is_file
    assert f.content_string == f'plantuml{os.linesep}'


@pytest.mark.parametrize('name', [
    'diagram.plantuml',
])
def test_that_template_specific_file_is_existing(host, name):
    f = host.file(f'{workspace_dir}/{name}')

    assert f.exists
    assert f.is_file
    assert f.size > 0
