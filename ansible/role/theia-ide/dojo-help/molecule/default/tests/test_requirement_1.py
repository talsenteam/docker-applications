import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_that_dojo_does_print_text_to_console(host):
    r = host.run('dojo')

    assert r.rc == 0
    assert r.stdout != ''


def test_that_dojo_build_help_does_print_text_to_console(host):
    r = host.run('dojo build --help')

    assert r.rc == 0
    assert r.stdout != ''


def test_that_dojo_cheat_help_does_print_text_to_console(host):
    r = host.run('dojo cheat --help')

    assert r.rc == 0
    assert r.stdout != ''


def test_that_dojo_history_help_does_print_text_to_console(host):
    r = host.run('dojo history --help')

    assert r.rc == 0
    assert r.stdout != ''


def test_that_dojo_init_help_does_print_text_to_console(host):
    r = host.run('dojo init --help')

    assert r.rc == 0
    assert r.stdout != ''


def test_that_dojo_new_workspace_help_does_print_text_to_console(host):
    r = host.run('dojo new-workspace --help')

    assert r.rc == 0
    assert r.stdout != ''


def test_that_dojo_rebuild_help_does_print_text_to_console(host):
    r = host.run('dojo rebuild --help')

    assert r.rc == 0
    assert r.stdout != ''


def test_that_dojo_url_help_does_print_text_to_console(host):
    r = host.run('dojo url --help')

    assert r.rc == 0
    assert r.stdout != ''
