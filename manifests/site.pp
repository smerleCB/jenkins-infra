## site.pp ##

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  server => 'puppet.jenkins.io',
  path   => false,
}

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  include profile::base
}

# archives
node 'archives.jenkins.io' {
  include role::archives
}

# radish
node 'puppet.jenkins.io' {
  sshkeyman::hostkey { 'puppet.jenkins.io': }
  include role::puppetmaster
}

# edamame
node 'edamame' {
  sshkeyman::hostkey { ['edamame.jenkins.io', 'edamame.jenkins-ci.org']: }
  include role::edamame
}

# lettuce
node 'lettuce' {
  sshkeyman::hostkey { ['lettuce.jenkins.io', 'lettuce.jenkins-ci.org']: }
  include role::lettuce
}

node 'census' {
  sshkeyman::hostkey { ['census.jenkins.io']: }
  include role::census
}

node 'usage' {
  sshkeyman::hostkey { ['usage.jenkins.io', 'usage.jenkins-ci.org']: }
  include role::usage
}

node 'pkg' {
  sshkeyman::hostkey { ['pkg.jenkins.io', 'pkg.origin.jenkins.io', 'updates.jenkins.io']: }
  include role::pkg
}

node 'oracle.updates.jenkins.io' {
  sshkeyman::hostkey { ['oracle.updates.jenkins.io']: }
  include role::updates
}

node 'azure.ci.jenkins.io' {
  sshkeyman::hostkey { ['azure.ci.jenkins.io']: }
  include role::jenkins::controller
}

# Jenkins controller for cert.ci.jenkins.io
node 'cert-ci' {
  sshkeyman::hostkey { ['cert.ci.jenkins.io']: }
  include role::privateci
}

node 'vpn.jenkins.io' {
  sshkeyman::hostkey { ['vpn.jenkins.io']: }
  include role::openvpn
}

node 'private.vpn.jenkins.io' {
  sshkeyman::hostkey { ['private.vpn.jenkins.io']: }
  include role::openvpn
}

## New VMs (Azure) for trusted.ci.jenkins.io
node 'bounce.trusted.ci.jenkins.io' {
  include role::bounce
}
node 'agent.trusted.ci.jenkins.io' {
  mount { '/home/jenkins':
    ensure => 'mounted',
    atboot => 'true',
    device => 'UUID=d87e9734-13a2-4e45-b906-6410a913c148',
    fstype => 'ext4',
  }
  include role::updatecenter
}
node 'controller.trusted.ci.jenkins.io' {
  mount { '/var/lib/jenkins':
    ensure => 'mounted',
    atboot => 'true',
    device => 'UUID=60de6f1a-4c88-47c6-928d-4dcb55e02f21',
    fstype => 'ext4',
  }
  include role::jenkins::controller
}
