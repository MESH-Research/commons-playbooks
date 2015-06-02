# Commons playbooks

This is a set of [Ansible][ansible] playbooks that provides a customized
[Commons-in-a-Box][cbox] installation in a production or development
environment. They were written for the [MLA Commons][commons] but could be
generally useful for any Debian-based LEMP stack. They can be used on
bare-metal, local-VM, or cloud-VM deployments.


## Dependencies

The only hard dependency is Ansible. On OS X, I use [Homebrew][brew]:

```sh
brew install ansible
```

The playbooks have been most recently tested with:

* OS X 10.10
* Ansible 1.9.1-1
* Vagrant 1.7.2
* Vagrant-AWS plugin 0.6.0
* VirtualBox 4.3.14


### Vagrant

Ansible provisioning is included in [Vagrant][vagrant], and I have included a
`Vagrantfile` for deploying to [VirtualBox][virtualbox] and Amazon EC2 (more
on each below).


### Wildcard DNS

(If you only want to use the Amazon EC2 provider, you can skip this section.)

Wildcard DNS resolution for WordPress Multisite on a local VM is a bit fraught,
and there are no quick and easy solutions. We use [DNSmasq][dnsmasq] to create
VMs under a dummy `.dev` TLD.

```sh
brew install dnsmasq
```

Pay close attention to the output of that command; there are some extra steps
you will need to take to make sure DNSmasq is running as a daemon on OS X.


Make sure `/etc/resolver/dev` exists and contains this line:

```sh
nameserver 127.0.0.1
```

Restarting your machine is a good idea at this point, to make sure the daemon
is working.

Next, make sure that Virtualbox is configured to provide private networking.
(This is the default behavior.) *Note:* Due to [a bug in VirtualBox][vbox-bug],
it may be necessary to remove the default `dhcpserver` from VirtualBox to
avoid collisions between multiple VMs by running this command:

```sh
VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0
```

Now, each time you create a new local VM, you will need to add an entry to
DNSmasq’s config file. Instructions are included in the VirtualBox section
below.


## Deploying to VirtualBox

The `Vagrantfile` expects a hostname to be passed as a parameter from your
`vagrant` command. This allows you to simply think up a hostname and then
summon it into existence with:

```sh
vagrant up hostname --provider=virtualbox
```

Other Vagrant commands work in the same way, e.g.:

```sh
vagrant ssh hostname
vagrant halt hostname
vagrant resume hostname
vagrant destroy hostname
```

Et cetera. This makes it easy to juggle multiple development VMs.

After creating a VM, you will need to add an entry to DNSmasq’s config file to
enable wildcard DNS resolution. First, determine the VM’s private IP address.
You can do this by connecting the machine via `vagrant ssh` and running
`ip addr`. Look for the private IP address assigned to `eth1`.

On OS X, add an entry to `/usr/local/etc/dnsmasq.conf`, substituting your
hostname and private IP address and flush the DNS cache.

```sh
echo "address=/hostname.dev/private-ip" >> /usr/local/etc/dnsmasq.conf
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo launchctl start homebrew.mxcl.dnsmasq
```

On GNU/Linux, the process is similar:

```sh
echo "address=/hostname.dev/private-ip" | sudo tee -a /etc/dnsmasq.conf
sudo service dnsmasq restart
```

Now you can browse to `https://hostname.dev` on your local machine and all 
network sites will work as expected.


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

If you’d like to set a default provider instead of using the `--provider` 
switch, set the `VAGRANT_DEFAULT_PROVIDER` environment variable.


[ansible]: http://www.ansible.com
[cbox]: http://commonsinabox.org
[commons]: http://commons.mla.org
[brew]: http://brew.sh
[dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[vagrant]: http://www.vagrantup.com
[vagrant-aws]: https://github.com/mitchellh/vagrant-aws
[virtualbox]: https://www.virtualbox.org
[vbox-bug]: https://github.com/mitchellh/vagrant/issues/3083
[best-practices]: http://docs.ansible.com/playbooks_best_practices.html
