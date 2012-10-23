# encoding: utf-8

default['mongodb']['db_name'] = 'igo_mongo_production'
default['mongodb']['backup_dir'] = '/opt/backups'
default['mongodb']['remote'] = 'remote-user@remote-ip'
default['mongodb']['remote_port'] = 22
default['mongodb']['do_mirror'] = 'false'