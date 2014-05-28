# Commons playbooks

This is a set of [Ansible][ansible] playbooks that can launch a WordPress
installation in a production or development environment. They were written for
the [MLA Commons][commons] but could be generally useful for any LEMP stack.
They can be used on bare-metal, local-VM, or cloud-VM deployments.

## Dependencies

The only hard dependency is Ansible >= 1.6. On OS X, I use [Homebrew][brew]:

```sh
brew install ansible
```

Ansible provisioning is included in [Vagrant][vagrant], and I have included
sample Vagrantfiles for deploying locally or to Amazon EC2. The latter requires
the [vagrant-aws][vagrant-aws] plugin:

```sh
vagrant plugin install vagrant-aws
```

The Vagrantfiles are designed to let you stand up a development server just by
typing:

```sh
vagrant up think-up-a-hostname --provider=aws
```


## Configuration

These playbooks were written to quarantine sensitive configuration values into
variables, which can be put in `groups_vars`, `host_vars`, or `ansible_hosts`.
Take a look at `group_vars/commons.yml`, which outlines some useful variables
and where you might put them. Before embarking, you will probably want to read
Ansible's documentation on [playbook best practices][best-practices].

It is assumed that you will use a local SSH config file and agent forwarding,
making it unnecessary to specify or transfer any private keys.


[ansible]: http://www.ansible.com
[commons]: http://commons.mla.org
[brew]: http://brew.sh
[vagrant]: http://www.vagrantup.com
[vagrant-aws]: https://github.com/mitchellh/vagrant-aws
[best-practices]: http://docs.ansible.com/playbooks_best_practices.html
