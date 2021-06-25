import datetime
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')

now = datetime.datetime.now()
date = now.strftime('%Y-%m-%d')
workspace_dir = f'/home/project/{date}-test'


def test_that_dojo_history_does_exit_successful(host):
    r = host.run(f'cd {workspace_dir} ; dojo history')

    assert r.rc == 0


def test_that_dojo_history_does_log_text_to_console(host):
    r = host.run(f'cd {workspace_dir} ; dojo history')
    stdout_lines = r.stdout.splitlines()

    assert stdout_lines[0] == '--> The workspace history is:'
    assert stdout_lines[1] == '--@ git log --oneline'
