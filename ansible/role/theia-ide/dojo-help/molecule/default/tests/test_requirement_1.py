import pytest
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


@pytest.mark.parametrize('command', [
    'dojo',
    'dojo build --help',
    'dojo cheat --help',
    'dojo duplicate --help',
    'dojo history --help',
    'dojo init --help',
    'dojo new-workspace --help',
    'dojo rebuild --help',
    'dojo url --help',
])
def test_that_command_does_print_text_to_console(host, command):
    r = host.run(command)

    assert r.rc == 0
    assert r.stdout != ''
