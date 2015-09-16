# Running

These Vagrant boxes have been most recently tested with:

* Vagrant 1.7.4
* VirtualBox 4.3.30

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

This requires some Vagrant plugins ([vagrant-aws][vagrant-aws], 
[vagrant-s3auth][vagrant-s3auth], and [landrush][landrush]) but Vagrant should
install them for you.


## Deploying to VirtualBox

```sh
vagrant up my-hostname --provider=virtualbox
```

Using NFS, Vagrant will create a synced folder between `./sync/my-hostname`
on the host machine and `/srv/www/commons/current` on the VM. When booting and
destroying VMs, Vagrant will ask for the *host machine’s* administrator
password so that it can modify `/etc/exports`.

After boot, the box will be available at `my-hostname.vagrant.dev`.

*Note:* Due to [a bug in VirtualBox][vbox-bug], it may be necessary to remove
the default `dhcpserver` from VirtualBox to avoid collisions between multiple
VMs by running this command:

```sh
VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0
```


## AWS

The `Vagrantfile` can also launch instances to Amazon EC2. It expects 
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to be defined as environment 
variables (with the requisite permissions). Now you can stand up a development 
server on EC2 by typing:

```sh
vagrant up my-hostname --provider=aws
```


## Import

To import a copy of the production environment and install the codebase, run 
`/srv/www/commons/bin/import.sh`.


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
[landrush]: https://github.com/phinze/landrush
[vbox-bug]: https://github.com/mitchellh/vagrant/issues/3083
