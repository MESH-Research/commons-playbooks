# Running

The `Vagrantfile` expects a hostname to be passed as a parameter from your
`vagrant` command. This allows you to simply think up a hostname and then
summon it into existence with:

```sh
vagrant up my-hostname --provider=[provider]
```

Other Vagrant commands work in the same way, e.g.:

```sh
vagrant ssh my-hostname
vagrant halt my-hostname
vagrant resume my-hostname
vagrant destroy my-hostname
```

Et cetera. This makes it easy to juggle multiple development VMs.

This requires some Vagrant plugins ([vagrant-aws][vagrant-aws] and 
[vagrant-s3auth][vagrant-s3auth]) but Vagrant should install them for you.


## Deploying to VirtualBox

```sh
vagrant up my-hostname --provider=virtualbox
```

Using NFS, Vagrant will create a synced folder between `./sync/my-hostname`
on the host machine and `/srv/www/commons/current` on the VM. When booting and
destroying VMs, Vagrant will ask for the *host machine’s* administrator
password so that it can modify `/etc/exports`.

### VirtualBox wildcard DNS

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
DNSmasq’s config file. First, determine the VM’s private IP address. You can do 
this by connecting the machine via `vagrant ssh` and running `ip addr`. Look 
for the private IP address assigned to `eth1`.

On OS X, add an entry to `/usr/local/etc/dnsmasq.conf`, substituting your
hostname and private IP address and flush the DNS cache.

```sh
echo "address=/my-hostname.dev/private-ip" >> /usr/local/etc/dnsmasq.conf
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo launchctl start homebrew.mxcl.dnsmasq
```

On GNU/Linux, the process is similar:

```sh
echo "address=/my-hostname.dev/private-ip" | sudo tee -a /etc/dnsmasq.conf
sudo service dnsmasq restart
```

Now you can browse to `https://my-hostname.dev` on your local machine and all 
network sites will work as expected.


## AWS

The `Vagrantfile` can also launch instances to Amazon EC2. It expects 
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to be defined as environment 
variables (with the requisite permissions). Now you can stand up a development 
server on EC2 by typing:

```sh
vagrant up my-hostname --provider=aws
```


## Configuration

If you’d like to set a default provider instead of using the `--provider` 
switch, set the `VAGRANT_DEFAULT_PROVIDER` environment variable.


## Updating boxes

Boxes are hosted remotely. Check for updated Vagrant boxes with:

```sh
vagrant box add s3://mla-vagrant/commons-dev/metadata.json
```


[vagrant-aws]: https://github.com/mitchellh/vagrant-aws
[vagrant-s3auth]: https://github.com/WhoopInc/vagrant-s3auth
[brew]: http://brew.sh
[dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[vbox-bug]: https://github.com/mitchellh/vagrant/issues/3083
