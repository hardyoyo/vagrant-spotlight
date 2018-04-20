# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "ubuntu/xenial64"

  # use my Samvera-Basebox
#  config.vm.box = "hardyoyo/Samvera-Basebox"
  config.vm.box = "geerlingguy/centos7"

  #skip the inserting of a key, because it's problematic and not needed
  config.ssh.insert_key = false


    # Turn off annoying console bells/beeps in Ubuntu (only if not already turned off in /etc/inputrc)
    config.vm.provision :shell, :name => "disable console beep", :inline => "echo 'Turning off console beeps...' && grep '^set bell-style none' /etc/inputrc || echo 'set bell-style none' >> /etc/inputrc"

    #------------------------
    # Enable SSH Forwarding
    #------------------------
    # Turn on SSH forwarding (so that 'vagrant ssh' has access to your local SSH keys, and you can use your local SSH keys to access GitHub, etc.)
    config.ssh.forward_agent = true

    # Prevent annoying "stdin: is not a tty" errors from displaying during 'vagrant up'
    # See also https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28288042
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Create a '/etc/sudoers.d/root_ssh_agent' file which ensures sudo keeps any SSH_AUTH_SOCK settings
    # This allows sudo commands (like "sudo ssh git@github.com") to have access to local SSH keys (via SSH Forwarding)
    # See: https://github.com/mitchellh/vagrant/issues/1303
    config.vm.provision :shell do |shell|
        shell.inline = "touch $1 && chmod 0440 $1 && echo $2 > $1"
        shell.args = %q{/etc/sudoers.d/root_ssh_agent "Defaults    env_keep += \"SSH_AUTH_SOCK\""}
        shell.name = "creating /etc/sudores.d/root_ssh_agent"
    end

    # Check if a test SSH connection to GitHub succeeds or fails (on every vagrant up)
    #
    config.vm.provision :shell, :name => "root: testing SSH connection to GitHub on VM", :inline => "echo 'root: Testing SSH connection to GitHub on VM...' && ssh -T -q -oStrictHostKeyChecking=no git@github.com", run: "always"

    # that was for root, do it again for vagrant
    config.vm.provision :shell, :name => "vagrant: testing SSH connection to GitHub on VM", :inline => "echo 'vagrant: Testing SSH connection to GitHub on VM...' && sudo -u vagrant ssh -T -q -oStrictHostKeyChecking=no git@github.com", run: "always"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

    #-----------------------------
    # HD Settings
    #-----------------------------
    # if we have the disksize plugin, request a specific disk size
    if Vagrant.has_plugin?('vagrant-disksize')
        config.disksize.size = '50GB'
    end

    #------------------------
    # Provisioning Scripts
    #    These scripts run in the order in which they appear, and setup the virtual machine (VM) for us.
    #------------------------

    # Shell script to set up swap space for this VM

    if File.exists?("config/increase-swap.sh")
        config.vm.provision :shell, :name => "creating a swap file", :inline => "echo '   > > > running local increase-swap.sh to ensure enough memory is available, via a swap file.'"
        config.vm.provision :shell, :name => "creating a swap file with a local increase-swap.sh script", :path => "config/increase-swap.sh"
    else
        config.vm.provision :shell, :name => "creating a swap file", :inline => "echo '   > > > running default increase-swap.sh scripte to ensure enough memory is available, via a swap file.'"
        config.vm.provision :shell, :name => "creating a swap file with the default increase-swap.sh script", :path => "increase-swap.sh"
    end

    # run ansible bootstrap
    config.vm.provision :shell, :name => "running ansible-bootstrap", :path => "ansible-boostrap-centos.sh"

    # # provision with ansible_local
    # config.vm.provision "ansible_local" do |ansible|
    #   ansible.playbook          = "playbook.yml"
    #   ansible.verbose           = true
    #   ansible.limit             = "local" #Yeah, don't do prod just yet, OK? Thanks!
    #   ansible.provisioning_path = "/vagrant/ansible"
    #   ansible.inventory_path    = "/vagrant/ansible/inventory"
    # end


    # Load any local customizations from the "local-bootstrap.sh" script (if it exists)
    # Check out the "config/local-bootstrap.sh.example" for examples
    if File.exists?("config/local-bootstrap.sh")
        config.vm.provision :shell, :inline => "echo '   > > > running config/local_bootstrap.sh (as vagrant)' && sudo -i -u vagrant /vagrant/config/local-bootstrap.sh"
    end


    # housekeeping
    config.vm.hostname = "spotlight"
    config.vm.network :private_network, ip: "192.168.33.33"

    # Set the name of the VM. See: http://stackoverflow.com/a/17864388/100134
    config.vm.define :spotlight do |spotlight|
    end

    # if we're running with vagrant-notify, send a notification that we're done, in case we've wandered off
    # https://github.com/fgrehm/vagrant-notify
    # NOTE: Currently this plugin only works on Linux or OSX hosts
    if Vagrant.has_plugin?('vagrant-notify')
        config.vm.provision :shell, :inline => "notify-send --urgency=critical -t 20000 'Vagrant-Ansible-Spotlight is up! Get back to work! :-)'", run: "always"
    end

    # Message to display to user after 'vagrant up' completes
    config.vm.post_up_message = "Setup of 'vagrant-ansible-spotlight' is now COMPLETE!\nYou can SSH into the new VM via 'vagrant ssh'"

end
