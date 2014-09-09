# manage filetest
class tomcat7 {

  package { 'wget':
    ensure => installed,
  }

  exec { 'apt-get update':
    command => 'apt-get update',
    path    => ['/usr/bin'],
  }

  package { 'openjdk-7-jdk':
    ensure  => installed,
    require => Exec['apt-get update'],
  }

  package { 'tomcat7':
    ensure  => installed,
    require => Package['openjdk-7-jdk'],
  }

  service { 'tomcat7':
    ensure  => running,
    require => Package['tomcat7'],
  }

  exec { 'sample-war':
    command => 'wget http://10.0.2.2:8080/job/PuppetJavaSample/lastSuccessfulBuild/artifact/target/traceability.war -P /tmp/',
    path    => ['/usr/bin'],
    require => [
      Service['tomcat7'],
      Package['wget']
    ],
  }

  exec { 'delete-war-from-webapps':
    command => 'rm -rf /var/lib/tomcat7/webapps/traceability*',
    path    => ['/bin'],
  }

  exec { 'delete-war-from-tmp':
    command => 'rm /tmp/traceability.war',
    path    => ['/bin'],
  }

  file { '/var/lib/tomcat7/webapps/traceability.war':
    source  => '/tmp/traceability.war',
    require => Exec['sample-war', 'delete-war-from-webapps'],
  }

}
