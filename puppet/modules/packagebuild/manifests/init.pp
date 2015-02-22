# install and configure fpm for the building of RPMS
class packagebuild {

  file { '/opt':
    ensure => directory,
    owner  => vagrant,
    group  => vagrant,
  }

  file { '/var/cache/omnibus':
    ensure => directory,
    owner  => vagrant,
    group  => vagrant,
  }

  $ruby_pkgs = [ 'ruby2.0-dev', 'ruby2.0' ]

  package { $ruby_pkgs:
    ensure => latest,
    notify => Exec['update-ruby'],
  }

  # Omnibus requires ruby 1.9 or later
  exec { 'update-ruby':
    refreshonly => true,
    command     => '/usr/bin/update-alternatives \
    --install /usr/bin/ruby ruby /usr/bin/ruby2.0 50 \
    --slave /usr/bin/irb irb /usr/bin/irb2.0 \
    --slave /usr/bin/rake rake /usr/bin/rake2.0 \
    --slave /usr/bin/gem gem /usr/bin/gem2.0 \
    --slave /usr/bin/rdoc rdoc /usr/bin/rdoc2.0 \
    --slave /usr/bin/testrb testrb /usr/bin/testrb2.0 \
    --slave /usr/bin/erb erb /usr/bin/erb2.0 \
    --slave /usr/bin/ri ri /usr/bin/ri2.0',
    user        => "root",
  }

  package { 'fpm':
    ensure   => latest,
    provider => gem,
    require  => [ Package[$ruby_pkgs], Exec['update-ruby'] ],
  }
  
  package { 'fpm-cookery':
    ensure   => latest,
    provider => gem,
    require  => [ Package[$ruby_pkgs], Exec['update-ruby'] ],
  }
  
  package { 'pleaserun':
    ensure   => latest,
    provider => gem,
    require  => [ Package[$ruby_pkgs], Exec['update-ruby'] ],
  }

  package { 'omnibus':
    ensure   => latest,
    provider => gem,
    require  => [ Package[$ruby_pkgs], Exec['update-ruby'] ],
  }

  package { 'bundler':
    ensure   => latest,
    provider => gem,
    require  => [ Package[$ruby_pkgs], Exec['update-ruby'] ],
  }


  $build_utils = [ 'build-essential', 'libpcre3-dev', 'unzip', 'libxml2-dev', 'libxslt1-dev', 'libgd2-xpm-dev', 'libgeoip-dev', 'python-setuptools', 'libgecode-dev' ]

  package { $build_utils:
    ensure  => latest,
    require => Package['fpm'],
  }

  $java_pkgs = [ 'tzdata-java', 'openjdk-7-jre-headless', 'openjdk-7-jre', 'openjdk-7-jdk' ]

  package { $java_pkgs:
    ensure  => latest,
  }

  # Mono build requirements

  $mono_build_essentials = [ 'mono-runtime', 'xsltproc', 'automake', 'gettext', 'libtool', 'autoconf', 'g++', 'libglib2.0-dev', 'libpng12-dev',
                             'libfreetype6-dev', 'libfontconfig1-dev', 'libx11-dev', 'libjpeg8-dev', 'libgif-dev', 'libexif-dev' ]

  $mongodb_build = [ 'scons', 'libssl-dev' ]

  package { $mono_build_essentials: 
    ensure => latest,
  }

  package { $mongodb_build:
    ensure => latest,
  }

}
