
Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |vb|
        vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    end

    $num_instances = 2

    (1..$num_instances).each do |i|
        config.vm.define "kubenode#{i}" do |node|
            node.vm.box = "generic/ubuntu2204"
            node.vm.hostname = "kubenode#{i}"
            ip = "192.168.17.#{i+200}"
            node.vm.network "private_network", ip: ip
            node.vm.network "forwarded_port", guest: 80, host: 8080 + i

            node.vm.provider "virtualbox" do |virtualbox|
                virtualbox.memory = "2048"
                # K8s requires at least 2 CPUs
                virtualbox.cpus = 2
                virtualbox.name = "kubenode#{i}"
            end

            node.vbguest.auto_update = true

            config.vm.provision :ansible do |ansible|
                ansible.playbook = "./ansible_playbooks/test_playbook.yml"
            end


        end
    end
end