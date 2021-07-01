import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


@pytest.mark.parametrize('executable', [
    'cccc',
    'cmake',
    'doctoc',
    'dotnet',
    'lcov',
    'meson',
    'ninja',
    'pandoc',
])
def test_that_directory_exists(host, executable):
    r = host.run(f'which {executable}')

    assert r.rc == 0
