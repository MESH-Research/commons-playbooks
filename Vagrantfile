# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use second parameter as machine name and hostname.
  if ("#{ARGV[0]}" != "" && "#{ARGV[1]}" == "")
    abort("Please provide a hostname, e.g.: `vagrant #{ARGV[0]} hostname`")
  end

  # Forward SSH credentials.
  config.ssh.forward_agent = true

  config.vm.define "#{ARGV[1]}" do |machine|

    # Use user-supplied hostname.
    machine.vm.hostname = "#{ARGV[1]}"

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
      aws.tags["Name"] = "#{ARGV[1]}"

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
        ansible.playbook = "../commons-playbooks/development.yml"

        # Send extra variables.
        ansible.extra_vars = {
          ansible_hostname: "#{ARGV[1]}",
          set_hostname: "#{ARGV[1]}"
        }

      end

    end

    # Virtualbox provider
    machine.vm.provider :virtualbox do |vb, override|

      # Ubuntu 12.04.
      override.vm.box = "hashicorp/precise64"

      # Synced folder.
      override.vm.synced_folder "sync/#{ARGV[1]}", "/vagrant/app", :create => "true"

      # Provision with Ansible.
      override.vm.provision :ansible do |ansible|

        # Point to Ansible resources.
        ansible.playbook = "../commons-playbooks/development.yml"

        # Send extra variables.
        ansible.extra_vars = {
          admin_user: "vagrant",
          ansible_ssh_host: "127.0.0.1",
          ansible_ssh_user: "vagrant",
          ansible_ssh_port: "2222",
          deploy_user: "vagrant",
          set_hostname: "#{ARGV[1]}",
          wordpress_install_directory: "/vagrant/app"
        }

      end

    end

  end

end
