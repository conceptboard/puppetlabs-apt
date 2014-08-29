class apt::params {
  $root           = '/etc/apt'
  $provider       = '/usr/bin/apt-get'
  $sources_list_d = "${root}/sources.list.d"
  $apt_conf_d     = "${root}/apt.conf.d"
  $preferences_d  = "${root}/preferences.d"

  case $::lsbdistid {
    'linuxmint': {
      $distid = $::lsbdistcodename ? {
        'debian' => 'debian',
        default  => 'ubuntu',
      }
      $distcodename = $::lsbdistcodename ? {
        'debian' => 'wheezy',
        'qiana'  => 'trusty',
        'petra'  => 'saucy',
        'olivia' => 'raring',
        'nadia'  => 'quantal',
        'maya'   => 'precise',
      }
    }
    'ubuntu', 'debian': {
      $distid = $::lsbdistid
      $distcodename = $::lsbdistcodename
    }
    '': {
      fail('Unable to determine lsbdistid, is lsb-release installed?')
    }
    default: {
      fail("Unsupported lsbdistid (${::lsbdistid})")
    }
  }
  case $distid {
    'debian': {
      case $distcodename {
        'squeeze': {
          $backports_location = 'http://backports.debian.org/debian-backports'
          $legacy_origin       = true
          $origins             = ['${distro_id} oldstable',
                                  '${distro_id} ${distro_codename}-security',
                                  '${distro_id} ${distro_codename}-lts']
        }
        'wheezy': {
          $backports_location = 'http://ftp.debian.org/debian/'
          $legacy_origin      = false
          $origins            = ['origin=Debian,archive=stable,label=Debian-Security']
        }
        default: {
          $backports_location = 'http://http.debian.net/debian/'
          $legacy_origin      = false
          $origins            = ['origin=Debian,archive=stable,label=Debian-Security']
        }
      }
    }
    'ubuntu': {
      case $distcodename {
        'lucid': {
          $backports_location = 'http://us.archive.ubuntu.com/ubuntu'
          $ppa_options        = undef
          $legacy_origin      = true
          $origins            = ['${distro_id} ${distro_codename}-security']
        }
        'precise', 'trusty': {
          $backports_location = 'http://us.archive.ubuntu.com/ubuntu'
          $ppa_options        = '-y'
          $legacy_origin      = true
          $origins            = ['${distro_id}:${distro_codename}-security']
        }
        default: {
          $backports_location = 'http://old-releases.ubuntu.com/ubuntu'
          $ppa_options        = '-y'
          $legacy_origin      = true
          $origins            = ['${distro_id}:${distro_codename}-security']
        }
      }
    }
  }
}
