# Check for missing plugin
required_plugins = ["vagrant-vbguest", "virtualbox_WSL2"]

plugin_installed = false


required_plugins.each do |plugin|
    unless Vagrant.has_plugin?(plugin)
        system("vagrant plugin install #{plugin}")
        plugin_installed = true
    end
end

# If new plugins installed, restart Vagrant process
if plugin_installed === true
    exec "vagrant #{ARGV.join' '}"
end

Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |vb|
        vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end

    # Defaults for config options
    $num_instances ||= 1
    # always use Vagrants secure key
    config.ssh.insert_key = true

    (1..$num_instances).each do |i|
        config.vm.define "kubentes#{i}" do |node|
            # node.vm.box = "generic/ubuntu2204"
            # node.vm.box = "ubuntu/bionic64"
            node.vm.box = "kuben"
            node.vm.hostname = "kubentes#{i}"
            ip = "192.168.17.#{i+200}"
            node.vm.network "private_network", ip: ip
            # node.vm.network "forwarded_port", guest: 80, host: 8080 + i

            node.vm.synced_folder ".", "/vagrant", disabled: true

            node.vm.provider "virtualbox" do |virtualbox|
                virtualbox.memory = "4048"
                # K8s requires at least 2 CPUs
                virtualbox.cpus = 2
                virtualbox.name = "kubentes#{i}"
            end
            node.vbguest.auto_update = true
        end
    end
    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "./ansible_playbooks/test_playbook.yml"
        ansible.compatibility_mode = "2.0"
        ansible.raw_arguments = ["--forks=#{$num_instances}", "--flush-cache"]
        ansible.verbose = "4"
    end
end
