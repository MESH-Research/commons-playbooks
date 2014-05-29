# Commons playbooks

This is a set of [Ansible][ansible] playbooks that launches a customized
[Commons-in-a-Box][cbox] installation in a production or development
environment. They were written for the [MLA Commons][commons] but could be
generally useful for any Debian-based LEMP stack. They can be used on
bare-metal, local-VM, or cloud-VM deployments.

## Dependencies

The only hard dependency is Ansible >= 1.6. On OS X, I use [Homebrew][brew]:

```sh
brew install ansible
```

## Vagrant

Ansible provisioning is included in [Vagrant][vagrant], and I have included a
`Vagrantfile` for deploying locally or to Amazon EC2. The latter requires the
[vagrant-aws][vagrant-aws] plugin:

```sh
vagrant plugin install vagrant-aws
```

This allows you to stand up a development server on AWS simply by typing:

```sh
vagrant up think-up-a-hostname --provider=aws
```

For [VirtualBox][virtualbox] deployment, omit the `--provider` switch. You will
need to add an entry to your local `/etc/hosts` file to resolve the hostname.

## Configuration

These playbooks were written to quarantine sensitive configuration values in a
file stored at `~/.ansible/commons.yml`. Use `group_vars/commons-example.yml`
as a template. Before embarking, you will probably want to read Ansible's
documentation on [playbook best practices][best-practices].

It is assumed that you will use a local SSH config file and agent forwarding,
making it unnecessary to specify or transfer any private keys.


[ansible]: http://www.ansible.com
[cbox]: http://commonsinabox.org
[commons]: http://commons.mla.org
[brew]: http://brew.sh
[vagrant]: http://www.vagrantup.com
[vagrant-aws]: https://github.com/mitchellh/vagrant-aws
[virtualbox]: https://www.virtualbox.org
[best-practices]: http://docs.ansible.com/playbooks_best_practices.html
