# -*- mode: ruby -*-
# vi: set ft=ruby :

options = {}

# Set hostname from command-line argument.
options[:hostname] = ARGV[1] || false

# Set playbook from environment variable.
options[:playbook] = ENV['PLAYBOOK'] || "../commons-playbooks/development.yml"

# Require the user to specify a hostname.
if ("#{ARGV[0]}" != "" && !options[:hostname])
  abort("Please provide a hostname, e.g.: `vagrant #{ARGV[0]} hostname`")
end


Vagrant.configure("2") do |config|

  # Forward SSH credentials.
  config.ssh.forward_agent = true

  config.vm.define options[:hostname] do |machine|

    # Use user-supplied hostname.
    machine.vm.hostname = options[:hostname]

    # AWS provider.
    machine.vm.provider :aws do |aws, override|

      # AWS credentials are stored in environment variables.
      aws.access_key_id = ENV['VAGRANT_AWS_ACCESS_KEY_ID']
      aws.secret_access_key = ENV['VAGRANT_AWS_SECRET_ACCESS_KEY']
      aws.keypair_name = ENV['VAGRANT_AWS_KEYPAIR_NAME']

      # Debian 7.5 wheezy x86_64 EBS us-east-1.
      aws.ami = "ami-2c886c44"
      aws.instance_type = "m1.small"
      aws.security_groups = "commons"

      # Create an Elastic IP and associate it with the instance.
      aws.elastic_ip = "true"

      # Set instance name to match hostname.
      aws.tags["Name"] = options[:hostname]

      # Override vagrant defaults.
      override.ssh.username = "admin"
      override.ssh.private_key_path = ENV['VAGRANT_AWS_PRIVATE_KEY']

      # Vagrant-AWS uses a dummy box.
      override.vm.box = "dummy"
      override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

      # Disable synced folder.
      override.vm.synced_folder ".", "/vagrant", :disabled => "true"

      # Provision with Ansible.
      override.vm.provision :ansible do |ansible|

        # Point to Ansible resources.
        ansible.playbook = options[:playbook]

        # Send extra variables.
        ansible.extra_vars = {
          ansible_hostname: options[:hostname],
          set_hostname: options[:hostname]
        }

      end

    end

    # Virtualbox provider
    machine.vm.provider :virtualbox do |vb, override|

      # Ubuntu 12.04.
      override.vm.box = "hashicorp/precise64"

      # Forward port.
      override.vm.network "forwarded_port", guest: 80, host: 9000, auto_correct: true

      # Synced folder.
      override.vm.synced_folder "sync/" + options[:hostname], "/vagrant", create: true

      # Provision with Ansible.
      override.vm.provision :ansible do |ansible|

        # Point to Ansible resources.
        ansible.playbook = options[:playbook]

        # Skip DNS for local VMs.
        ansible.skip_tags = "route53-dns,permissions"

        # Send extra variables.
        ansible.extra_vars = {
          admin_user: "vagrant",
          ansible_ssh_host: "127.0.0.1",
          ansible_ssh_user: "vagrant",
          ansible_ssh_port: "2222",
          deploy_user: "vagrant",
          set_hostname: options[:hostname],
          wordpress_hostname: options[:hostname] + ".dev",
          wordpress_install_directory: "/vagrant/app",
          www_user: "vagrant"
        }

      end

    end

  end

end
