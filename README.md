# Commons playbooks

This is a set of [Ansible][ansible] playbooks and [Packer][packer] templates 
that produce a customized [Commons-in-a-Box][cbox] installation, in the form of
Amazon EC2 AMIs and Vagrant boxes. It was written for [MLA Commons][commons] 
but could be adapted for other purposes.

This project has two sets of target users: builders and runners. “Builders” 
use Ansible and Packer to create AMIs and Vagrant boxes. The “runners” use 
[Vagrant][vagrant] and a provided `Vagrantfile` to spin up resources.


## Building

Please see [packer/README.md](packer/README.md).


## Running

Please see [vagrant/README.md](vagrant/README.md).


[ansible]: http://www.ansible.com
[packer]: http://packer.io
[cbox]: http://commonsinabox.org
[commons]: http://commons.mla.org
[vagrant]: http://www.vagrantup.com
