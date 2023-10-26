
Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |vb|
        vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end

    $num_instances = 3

    (1..$num_instances).each do |i|
        config.vm.define "kubenode#{i}" do |node|
            node.vm.box = "generic/ubuntu2204"
            node.vm.hostname = "kubenode#{i}"
            ip = "192.168.17.#{i+200}"
            node.vm.network "private_network", ip: ip

            node.vm.provider "virtualbox" do |virtualbox|
                virtualbox.memory = "2048"
                # K8s requires at least 2 CPUs
                virtualbox.cpus = 2
                virtualbox.name = "kubenode#{i}"
            end

        end
    end
end