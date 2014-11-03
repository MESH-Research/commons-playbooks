# -*- mode: ruby -*-
# vi: set ft=ruby :

options = {}

# Set hostname from command-line argument.
options[:hostname] = ARGV[1] || false

# Set playbook from environment variable.
options[:playbook] = ENV['PLAYBOOK'] || "development.yml"

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

      # Debian 7.7 wheezy hvm x86_64 ebs us-east-1.
      aws.ami = "ami-a458e2cc"
      aws.instance_type = "t2.small"
      aws.security_groups = ENV['VAGRANT_AWS_SECURITY_GROUP']
      aws.subnet_id = ENV['VAGRANT_AWS_SUBNET_ID']

      # Use IAM role.
      aws.iam_instance_profile_name = "commons-dev"

      # Associate a public IP with the instance.
      aws.associate_public_ip = "true"

      # Set instance tags.
      aws.tags["Name"] = options[:hostname]
      aws.tags["Project"] = "commons"

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

      # Use private networking.
      override.vm.network "private_network", type: "dhcp"

      # Synced folder.
      override.vm.synced_folder "sync/" + options[:hostname], "/vagrant", create: true

      # Provision with Ansible.
      override.vm.provision :ansible do |ansible|

        # Point to Ansible resources.
        ansible.playbook = options[:playbook]

        # Skip DNS and file permissions for local VMs.
        if ( options[:playbook] == "development.yml" )
          ansible.skip_tags = "route53-dns,permissions"
        end

        # Send extra variables.
        ansible.extra_vars = {
          admin_user: "vagrant",
          ansible_ssh_host: "127.0.0.1",
          ansible_ssh_user: "vagrant",
          ansible_ssh_port: "2222",
          deploy_user: "vagrant",
          nginx_sendfile: "off",
          set_hostname: options[:hostname],
          wordpress_hostname: options[:hostname] + ".dev",
          wordpress_install_directory: "/vagrant/app",
          www_user: "vagrant"
        }

      end

    end

  end

end
