# Commons playbooks

This is a set of [Ansible][ansible] playbooks that provides a customized
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
`Vagrantfile` for deploying to [VirtualBox][virtualbox]. You will need to add
an entry to your local `hosts` file to resolve the hostname (WordPress
multisite does not allow browsing by IP address).

## AWS

The `Vagrantfile` can also launch instances to Amazon EC2 with minimal
configuration. You'll need the [vagrant-aws][vagrant-aws] plugin:

```sh
vagrant plugin install vagrant-aws
```

It also requires a few environment variables: `VAGRANT_AWS_ACCESS_KEY_ID`,
`VAGRANT_AWS_SECRET_ACCESS_KEY`, `VAGRANT_AWS_KEYPAIR_NAME`, and
`VAGRANT_AWS_PRIVATE_KEY`. Now you can stand up a development server on EC2
just by typing:

```sh
vagrant up think-up-a-hostname --provider=aws
```

There's also a Ansible role that updates DNS records for a development domain
using Amazon Route 53. You'll need to provide `route53_zone_id` to Ansible to
enable it (see "Configuration," below).

## Configuration

These playbooks were written to quarantine sensitive configuration values in a
file stored at `~/.ansible/commons.yml`. Use `group_vars/vanilla-cbox.yml` as a
template. Before embarking, you will probably want to read Ansible's
documentation on [playbook best practices][best-practices].

It is assumed that you will use a local SSH config file (or `vagrant ssh`) and
agent forwarding, making it unnecessary to specify or transfer any private keys.


[ansible]: http://www.ansible.com
[cbox]: http://commonsinabox.org
[commons]: http://commons.mla.org
[brew]: http://brew.sh
[vagrant]: http://www.vagrantup.com
[vagrant-aws]: https://github.com/mitchellh/vagrant-aws
[virtualbox]: https://www.virtualbox.org
[best-practices]: http://docs.ansible.com/playbooks_best_practices.html
