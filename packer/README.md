# Building

To build, you need [Ansible][ansible] and [Packer][packer]. On OS X, I use 
[Homebrew][brew]:

```sh
brew install ansible packer
```

The playbooks and templates have been most recently tested with:

* OS X 10.10
* Ansible 1.9.1-1
* Packer 0.7.5

Next install the playbook dependencies:

```sh
git submodule update --init --recursive
cd ansible
ansible-galaxy install -r requirements.yml
```

Configure your build by copying the `ansible/env_vars/commons.yml.example` 
template and populating it.

Now you’re ready to build:

```sh
cd ../packer
packer build packer.json
```

[ansible]: http://www.ansible.com
[packer]: http://packer.io
[brew]: http://brew.sh
