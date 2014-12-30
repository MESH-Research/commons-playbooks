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
`Vagrantfile` for deploying to [VirtualBox][virtualbox]. However, wildcard DNS
resolution for WordPress Multisite on a VM is a bit fraught, and there are no
quick and easy solutions. Explaining our solution is a bit out of scope for this
README, but we create VMs under a `.dev` domain with the following supporting
characters:

1. [DNSmasq][dnsmasq]
2. An `/etc/resolver/dev` file containing one line: `nameserver 127.0.0.1`
3. Private networking for the VM provided by Vagrant
4. Entries in `/usr/local/etc/dnsmasq.conf`

With this approach, you can:

```sh
vagrant up hostname
echo "address=/[hostname].dev/[private-ip]" >> /usr/local/etc/dnsmasq.conf
```

On GNU/Linux, the process is similar: 

```sh
vagrant up hostname
echo "address=/[hostname].dev/[private-ip]" | sudo tee -a /etc/dnsmasq.conf
sudo service dnsmasq restart
```

Note: due to [a bug in VirtualBox](https://github.com/mitchellh/vagrant/issues/3083), it may be necessary to remove the default `dhcpserver` from VirtualBox to avoid collisions by running the command `VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0`. 

After the VM is provisioned, you can browse to `http://hostname.dev` on your
local machine and all network sites will work as expected.

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
vagrant up [hostname] --provider=aws
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
[dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[vagrant]: http://www.vagrantup.com
[vagrant-aws]: https://github.com/mitchellh/vagrant-aws
[virtualbox]: https://www.virtualbox.org
[best-practices]: http://docs.ansible.com/playbooks_best_practices.html
