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
    r = host.run(f'cd {workspace_dir} ; dojo url')

    assert r.rc == 0


def test_that_dojo_history_does_log_text_to_console(host):
    r = host.run(f'cd {workspace_dir} ; dojo url')
    stdout_lines = r.stdout.splitlines()

    assert stdout_lines[1] == f'      http://localhost/#{workspace_dir}'
    assert stdout_lines[3] == f'      http://localhost/#{workspace_dir}'
