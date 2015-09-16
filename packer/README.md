# Building

To build, you need [Ansible][ansible] and [Packer][packer]. On OS X, I use 
[Homebrew][brew]:

```sh
brew install ansible packer
```

The playbooks and templates have been most recently tested with:

* OS X 10.10
* Ansible 1.9.3
* Packer 0.8.6
* VirtualBox 4.3.30

Next install the playbook dependencies:

```sh
git submodule update --init --recursive
cd ansible && ansible-galaxy install -f -r requirements.yml
```

Configure your build by copying the `ansible/vars/config.yml` 
template to `~/.ansible/commons.yml` and populating it.

Now you’re ready to build. In the `packer` directory, run:

```sh
packer build packer.json
```

Boxes are self-hosted on Amazon S3. Use `packer/builds/metadata.json.example` 
as a template for your [box file][vagrant-box].

[ansible]: http://www.ansible.com
[packer]: http://packer.io
[brew]: http://brew.sh
[vagrant-box]: http://docs.vagrantup.com/v2/boxes/format.html
