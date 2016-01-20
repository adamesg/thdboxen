require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::homebrewdir}/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  nodejs::version { '0.8': }
  nodejs::version { '0.10': }
  nodejs::version { '0.12': }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.8': }
  ruby::version { '2.2.4': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}

  ## Install CloudFoundry
  ## brew tap pivotal/tap
  homebrew::tap { 'pivotal/tap': }
  
  ## brew install cloudfoundry-cli
  package { "pivotal/tap/cloudfoundry-cli":
    ensure => present,
    require => Homebrew::Tap['pivotal/tap'],
  } ## -> installs `cloudfoundry-cli` to `/opt/boxen/homebrew/Cellar/cloudfoundry-cli/`

 include iterm2::stable 
 include slack

class slack (
  $version = '1.1.10'
) {
  # Application in a .zip
  package { 'Slack':
    ensure   => present,
    source   => "https://slack-ssb-updates.global.ssl.fastly.net/mac_public_releases/slack-${version}.zip",
    provider => compressed_app
  }
}

  package { "IntelliJ-IDEA-IU-15.0.3":
    provider => 'appdmg_eula',
    source   => "http://download.jetbrains.com/idea/ideaIU-15.0.3.dmg",
  }
 

include brewcask
package { 'java': provider => 'brewcask' } 

  package { 'CiscoAnyConnect':
    source => '/Users/comdev/Desktop/corpdeploy/Install and-or add to Dock/anyconnect-macosx-i386-3.1.12020-k9-2.dmg',
    provider => pkgdmg,
  }

  package {'SEP' :
    source => '/Users/comdev/Desktop/corpdeploy/SEP 12.1 R6 MP2/SEP 12.1 R6 MP2 Application Installer/Additional Resources/SEP.mpkg',
    provider => apple,
  }

  package { 'Outlook':
    source => '/Users/comdev/Desktop/Microsoft_Office_2016_Volume_Installer.pkg',
    provider => apple,
  }

  package { 'AirWatch':
    source => '/Users/comdev/Downloads/AirWatchAgent.dmg',
    provider => pkgdmg,
  }

  file { 'HD-Firewall':
    source => '/Users/comdev/Desktop/corpdeploy/Install and-or add to Dock/HD-Firewall.term',
    path => '/Applications/HD-Firewall.term',
  }



#  class associate-user {
#    include 'stdlib'
#    $pass = str2saltedsha512('password')
#    puts $pass
#    user { 'testuser':
#       ensure  => 'present',
#       comment => 'TestUser,,,',
#       groups  => ['staff', 'everyone'],
#       home    => '/Users/testuser',
#       shell   => '/bin/bash',
#       password => $pass,
#     }
#  }
#
#  include associate-user
