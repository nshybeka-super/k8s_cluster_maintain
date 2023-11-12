# Defaults for config options
$num_masters ||= 1
$num_workers ||= 2

# Generates a hosts file for a Kubernetes cluster when the Vagrant command 'up' is invoked.
# Executes the script './hosts_file_generation.sh' to create the hosts file based on specified master and worker node counts.
system("
    if [ #{ARGV[0]} = 'up' ]; then
        echo 'Generate hosts file for our kubernetes cluster..'
        ./hosts_file_generation.sh #{$num_masters} #{$num_workers}
    fi
")

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



    # always use Vagrants secure key
    config.ssh.insert_key = true

    (1..$num_masters).each do |i|
        config.vm.define "kubentes-master#{i}" do |node|
            # node.vm.box = "generic/ubuntu2204"
            # node.vm.box = "ubuntu/bionic64"
            node.vm.box = "kuben"
            node.vm.hostname = "kubentes-master#{i}"
            ip = "192.168.17.#{i+200}"
            node.vm.network "private_network", ip: ip, virtualbox__intnet: "mynetwork"
            # node.vm.network "forwarded_port", guest: 80, host: 8080 + i

            node.vm.synced_folder ".", "/vagrant", disabled: true

            node.vm.provider "virtualbox" do |virtualbox|
                virtualbox.memory = "2024"
                # K8s requires at least 2 CPUs
                virtualbox.cpus = 2
                virtualbox.name = "kubentes-master#{i}"
            end
            node.vbguest.auto_update = true
        end
    end

    (1..$num_workers).each do |i|
        config.vm.define "kubentes-worker#{i}" do |node|
            # node.vm.box = "generic/ubuntu2204"
            # node.vm.box = "ubuntu/bionic64"
            node.vm.box = "kuben"
            node.vm.hostname = "kubentes-worker#{i}"
            ip = "192.168.17.#{i+100}"
            node.vm.network "private_network", ip: ip, virtualbox__intnet: "mynetwork"
            # node.vm.network "forwarded_port", guest: 80, host: 8080 + i

            node.vm.synced_folder ".", "/vagrant", disabled: true

            node.vm.provider "virtualbox" do |virtualbox|
                virtualbox.memory = "2024"
                # K8s requires at least 2 CPUs
                virtualbox.cpus = 2
                virtualbox.name = "kubentes-worker#{i}"
            end
            node.vbguest.auto_update = true
        end
    end

    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "./ansible_playbooks/install_basic_stuff.yml"
        ansible.compatibility_mode = "2.0"
        ansible.raw_arguments = ["-e num_masters=#{$num_masters}", "-e num_workers=#{$num_workers}"]
        ansible.verbose = "4"
    end
end
