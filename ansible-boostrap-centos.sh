#!/usr/bin/env bash
#
# This bootstraps Ansible & Librarian-Ansible on CentOS7.
# Based on the script at: https://github.com/hashicorp/puppet-bootstrap/
#
# However, we've updated it to also install and configure librarian-ansible
# We use librarian-ansible to auto-install 3rd party Ansible roles.
#
set -e

#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Install wget if we have to (just being safe)
echo "Installing wget..."
yum --assumeyes install wget >/dev/null

# Install Ansible
echo "Installing Ansible..."
yum --assumeyes install epel-release >/dev/null
yum --assumeyes --nogpgcheck install ansible >/dev/null
echo "Ansible installed!"

# Install Ruby
echo "Installing Ruby..."
yum --assumeyes install ruby >/dev/null
echo "Ansible installed!"

### Start librarian-ansible installation & initialization

# Install Git
echo "Installing Git..."
yum --assumeyes install git >/dev/null
echo "Git installed!"

# Install 'librarian-ansible' and all third-party roles configured in Ansiblefile
if [ "$(gem search -i librarian-ansible)" = "false" ]; then
  echo "Installing librarian-ansible..."
  gem install --no-ri --no-rdoc librarian-ansible >/dev/null
  echo "librarian-ansible installed!"

# TODO: the following won't work in the same script on CentOS, you'll need to move it to a new provisioner

  echo "Installing third-party Ansible roles (via librarian-ansible)..."
  cd /vagrant && sudo -u vagrant /usr/local/bin/librarian-ansible install --clean
else
  echo "Updating third-party Ansible roles (via librarian-ansible)..."
  cd /vagrant && sudo -u vagrant /usr/local/bin/librarian-ansible update
fi
