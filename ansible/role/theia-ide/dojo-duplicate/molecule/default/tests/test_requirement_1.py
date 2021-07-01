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
duplicated_workspace_dir = f'/home/project/{date}-test-2'
workspace_name_marker_location = '.workspace/.name'


def test_that_duplicated_workspace_directory_exists(host):
    d = host.file(f'{duplicated_workspace_dir}')

    assert d.exists
    assert d.is_directory


@pytest.mark.parametrize('name', [
    'src/dummy.c',
    'src/dummy.h',
    'test/test_dummy.c',
    '.gitignore',
    'project.yml',
])
def test_that_template_specific_file_is_existing(host, name):
    r = host.run(f'diff --brief --recursive {workspace_dir}/{name} {duplicated_workspace_dir}/{name}')

    assert r.rc == 0
