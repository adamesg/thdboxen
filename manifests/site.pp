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

#  class associate-user {
#    user { 'testuser':
#       ensure  => 'present',
#       comment => 'TestUser',
#       #groups  => 'staff',
#       home    => '/Users/testuser/',
#       shell   => '/bin/bash',
#       iterations => '47169',
#       password   => '92cf23f437de506de1fd11ec1088f7f7ebb94c1a4f3937581fc9095c37ac059c7bffd5cdb216dbd6cb5ee8c78d1f20e23d4e131db12d98b468ed40a86f782d625b33296b5b1e2098e05d2cb5bb4ac5e71883dc8f687b5040eaf82178d175fd313f8301823150cba34dd613acdd334655d26848807b57dba413941cae4220bab7',
#       salt       => 'd2d2321fff5ef4bd6571605052329ee21d3f75197f8ed7b956b50ff1a9b1b853',
#       name => 'testUser',
#       gid => '20',
#     }
#  }
#
#  include associate-user

###### DMGs
  package { 'AndroidStudio' :
    source => '/Volumes/DEPS/android-studio-ide-141.2456560-mac.dmg',
    provider => appdmg,
  }

  package { 'Balsamiq' :
    source => '/Volumes/DEPS/Balsamiq_Mockups_3.3.6.dmg',
    provider => appdmg,
  }

  package { 'CiscoAnyConnect' :
    source => '/Volumes/DEPS/anyconnect-macosx-i386-3.1.12020-k9-2.dmg',
    provider => appdmg,
  }

  package { 'DBVisualizer' :
    source => '/Volumes/DEPS/dbvis_macos_9_2_14_jre.dmg',
    provider => appdmg,
  }

  package { 'Firefox' :
    source => '/Volumes/DEPS/Firefox 44.0.dmg',
    provider => appdmg,
  }

  package { 'GoogleChrome' :
    source => '/Volumes/DEPS/googlechrome.dmg',
    provider => appdmg,
  }

  package { 'IntelliJ IDEA' :
    source => '/Volumes/DEPS/ideaIU-15.0.3.dmg',
    provider => appdmg,
    before => Package['Java8'],
  }

  package { 'Java8' :
    source => '/Volumes/DEPS/jdk-8u71-macosx-x64.dmg',
    provider => appdmg,
  }

#  package { 'OmniGraffle' :
#    source => '/Volumes/DEPS/OmniGraffle-6.4.1.dmg',
#    provider => appdmg,
#  }

  package { 'RubyMine' :
    source => '/Volumes/DEPS/RubyMine-8.0.3-custom-jdk-bundled.dmg',
    provider => appdmg,
  }

  package { 'SourceTree' :
    source => '/Volumes/DEPS/SourceTree_2.1.dmg',
    provider => appdmg,
  }

  package { 'Vagrant' :
    source => '/Volumes/DEPS/vagrant_1.8.1.dmg',
    provider => appdmg,
  }

  package { 'Webstorm' :
    source => '/Volumes/DEPS/WebStorm-11.0.3-custom-jdk-bundled.dmg',
    provider => appdmg,
  }

#### PKGS

  package { 'AirWatch':
    source => '/Volumes/DEPS/Install AirWatch MDM Agent.pkg',
    provider => apple,
  }

  package { 'PCF CLI':
    source => '/Volumes/DEPS/cf-cli-installer_6.15.0_osx.pkg',
    provider => apple,
  }

  package { 'go':
    source => '/Volumes/DEPS/go1.5.3.darwin-amd64.pkg',
    provider => apple,
  }

  package { 'MSOffice':
    source => '/Volumes/DEPS/Microsoft_Office_2016_Volume_Installer.pkg',
    provider => apple,
  }

  package { 'Lync' :
    source => '/Volumes/DEPS/lync.pkg',
    provider => apple,
  }

  package { 'Node':
    source => '/Volumes/DEPS/node-v4.2.6.pkg',
    provider => apple,
  }

  package { 'THDEclipse' :
    source => '/Volumes/DEPS/THDEclipse_4.4.pkg',
    provider => apple,
    before => Package['Java8'],
  }

  package { 'VirtualBox' :
    source => '/Volumes/DEPS/VirtualBox.pkg',
    provider => apple,
  }

### .apps

  exec { 'Alfred2' :
    command => 'sudo cp -r  /Volumes/DEPS/Alfred\ 2.app /Applications',
    path => $path,
  }

  exec { 'Atom' :
    command => 'sudo cp -r  /Volumes/DEPS/Atom.app /Applications',
    path => $path,
  }

  exec { 'BeyondCompare' :
    command => 'sudo cp -r  /Volumes/DEPS/Beyond\ Compare.app /Applications',
    path => $path,
  }

  exec { 'Cyberduck' :
    command => 'sudo cp -r  /Volumes/DEPS/Cyberduck.app /Applications',
    path => $path,
  }

  exec { 'GitX' :
    command => 'sudo cp -r  /Volumes/DEPS/GitX.app /Applications',
    path => $path,
  }

  exec { 'iTerm2' :
    command => 'sudo cp -r  /Volumes/DEPS/iTerm.app /Applications',
    path => $path,
  }

  exec { 'Sketch' :
    command => 'sudo cp -r  /Volumes/DEPS/Sketch.app /Applications',
    path => $path,
  }

  exec { 'Slack' :
    command => 'sudo cp -r  /Volumes/DEPS/Slack.app /Applications',
    path => $path,
  }

### Scripts/Commands
  exec { 'IDEPrefs' :
    command => 'sudo cp -r /Volumes/DEPS/pivotal_ide_prefs-master /opt; cd /opt/pivotal_ide_prefs-master/cli; ./bin/ide_prefs --ide=intellij install; ./bin/ide_prefs --ide=rubymine install',
    path => $path,
    require => Package['IntelliJ IDEA'],
  }

  exec { 'Node-Inspector' :
    command => 'npm install /Volumes/DEPS/node-inspector-master',
    path => $path,
    require => Package['Node'],
  }

  exec { 'Gulp' :
    command => 'npm install /Volumes/DEPS/gulp-master',
    path => $path,
    require => Package['Node'],
  }

  exec { 'Grunt' :
    command => 'npm install /Volumes/DEPS/grunt-master',
    path => $path,
    require => Package['Node'],
  }

  exec { 'Redis-CLI' :
    command => 'sudo cp /Volumes/DEPS/redis-cli /usr/local/bin; sudo chmod 755 /usr/local/bin/redis-cli',
    path => $path,
  }

### Local Gems
  exec { 'Git-Pair' :
    command => 'sudo gem install /Volumes/DEPS/git-pair-0.1.0.gem',
    path => $path,
  }

### Files
  file { 'HD-Firewall':
    source => '/Volumes/DEPS/HD-Firewall.term',
    path => '/Applications/HD-Firewall.term',
  }
