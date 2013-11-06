# Class: nginx::param
#
# This module manages NGINX paramaters
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# nx_events_use: One of [kqueue|rtsig|epoll|/dev/poll|select|poll|eventport]
#                or false to use OS default
#
# This class file is not called directly
class nginx::params (
  $nx_temp_dir                    = '/tmp',
  $nx_run_dir                     = '/var/nginx',

  $nx_conf_dir                    = '/etc/nginx',
  $nx_ssl_dir                     = '/etc/ssl/nginx',
  $nx_confd_purge                 = false,
  $nx_worker_processes            = 1,
  $nx_worker_connections          = 1024,
  $nx_types_hash_max_size         = 1024,
  $nx_types_hash_bucket_size      = 512,
  $nx_names_hash_bucket_size      = 64,
  $nx_multi_accept                = off,
  $nx_events_use                  = false,
  $nx_sendfile                    = on,
  $nx_keepalive_timeout           = '75 20',
  $nx_tcp_nodelay                 = on,
  $nx_tcp_nopush                  = on,
  $nx_hash                        = on,
  $nx_server_tokens               = on,
  $nx_spdy                        = off,
  $nx_ssl_stapling                = off,
  $nx_ignore_invalid_headers      = on,

  $nx_client_header_timeout       = '10m',
  $nx_client_body_timeout         = '10m',
  $nx_send_timeout                = '10m',

  $nx_error_log_level             = 'info',
  $nx_log_format                  = off,
  $nx_log_format_name             = 'default',
  $nx_log_description             = [
    '\'$remote_addr - $remote_user [$time_local] \'',
    '\'"$request" $status $bytes_sent \'',
    '\'"$http_referer" "$http_user_agent" "$http_x_forwarded_for" \'',
    '\'"$gzip_ratio"\';',
  ],

  $nx_connection_pool_size        = 256,
  $nx_client_header_buffer_size   = '1k',
  $nx_large_client_header_buffers = '4 2k',
  $nx_request_pool_size           = '4k',

  $nx_gzip                        = on,
  $nx_gzip_min_length             = 1100,
  $nx_gzip_buffers                = '4 8k',
  $nx_gzip_types                  = 'text/plain',

  $nx_ssl_global                  = on,
  $nx_ssl_protocols               = 'SSLv3 TLSv1 TLSv1.1 TLSv1.2',
  $nx_ssl_ciphers                 = 'ECDHE-RSA-AES256-SHA384:AES256-SHA256:RC4:HIGH:!MD5:!aNULL:!EDH:!AESGCM',
  $nx_ssl_prefer_server_ciphers   = on,
  $nx_ssl_session_cache           = 'shared:SSL:10m',
  $nx_ssl_session_timeout         = '10m',

  $nx_output_buffers              = '1 32k',
  $nx_postpone_output             = 1460,
  $nx_index                       = 'index.html',

  $nx_proxy_redirect              = off,
  $nx_proxy_set_header            = [
    'Host $host',
    'X-Real-IP $remote_addr',
    'X-Forwarded-For $proxy_add_x_forwarded_for',
  ],
  $nx_proxy_cache_path            = false,
  $nx_proxy_cache_levels          = 1,
  $nx_proxy_cache_keys_zone       = 'd2:100m',
  $nx_proxy_cache_max_size        = '500m',
  $nx_proxy_cache_inactive        = '20m',

  $nx_client_body_buffer_size     = '128k',
  $nx_client_max_body_size        = '10m',
  $nx_proxy_connect_timeout       = '90',
  $nx_proxy_send_timeout          = '90',
  $nx_proxy_read_timeout          = '90',
  $nx_proxy_buffers               = '32 4k',
  $nx_proxy_http_version          = '1.0',
  $nx_proxy_buffer_size           = '8k'
)
{
  $nx_client_body_temp_path   = "${nx_run_dir}/client_body_temp"
  $nx_proxy_temp_path         = "${nx_run_dir}/proxy_temp"

  $nx_logdir = $::kernel ? {
    /(?i-mx:linux)/ => '/var/log/nginx',
  }

  $nx_pid = $::kernel ? {
    /(?i-mx:linux)/  => '/var/run/nginx.pid',
  }

  $nx_daemon_user = $::operatingsystem ? {
    /(?i-mx:debian|ubuntu)/                                                    => 'www-data',
    /(?i-mx:fedora|rhel|redhat|centos|scientific|suse|opensuse|amazon|gentoo)/ => 'nginx',
  }

  if $::operatingsystem == 'gentoo' {
    $nx_daemon_group = 'nginx'
  }
  else
  {
    $nx_daemon_group = 'root'
  }

  # Service restart after Nginx 0.7.53 could also be just
  # "/path/to/nginx/bin -s HUP" Some init scripts do a configtest, some don't.
  # If configtest_enable it's true then service restart will take
  # $nx_service_restart value, forcing configtest.

  $nx_configtest_enable = false
  $nx_service_restart = '/etc/init.d/nginx configtest && /etc/init.d/nginx restart'

  $nx_mail = false

  $nx_http_cfg_append = false

  $nx_nginx_error_log = "${nx_logdir}/error.log"
  $nx_http_access_log = "${nx_logdir}/access.log"

  # package name depends on distribution, e.g. for Debian nginx-full | nginx-light
  $package_name   = 'nginx'
  $package_ensure = 'present'
  $package_source = 'nginx'
  $manage_repo    = true
}
