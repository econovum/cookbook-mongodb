# encoding: utf-8
#Security
default['mongodb']['port'] = 27017

#Replication set parameters
default['mongodb']['set_name'] = 'set0'

#Backup parameters
default['mongodb']['db_name'] = 'igo_mongo_production'
default['mongodb']['backup_dir'] = '/opt/backups'
default['mongodb']['remote'] = ''
default['mongodb']['remote_port'] = 22
default['mongodb']['remote_dir'] = '/opt/backups'
default['mongodb']['local'] = ''
default['mongodb']['do_mirror'] = 'false'

