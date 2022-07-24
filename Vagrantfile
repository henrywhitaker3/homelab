Vagrant.configure("2") do |config|
    config.vm.box = "generic/ubuntu2004"

    config.ssh.insert_key = false

    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.provider :libvirt do |libvirt|
        libvirt.cpus = 1
        libvirt.memory = 512
    end

    # App server
    config.vm.define "docker-v" do |docker|
        docker.vm.hostname = "docker-v.localhost"
        docker.vm.network:private_network, ip:"10.1.0.2"
    end

    # k8s management server
    config.vm.define "k8s-admin" do |k8s_admin|
        k8s_admin.vm.hostname = "k8s-admin.localhost"
        k8s_admin.vm.network:private_network, ip:"10.1.0.5"
    end
    # k8s-01
    config.vm.define "k8s-01" do |k8s_01|
        k8s_01.vm.hostname = "k8s-01.localhost"
        k8s_01.vm.network:private_network, ip:"10.1.0.6"
    end
    # k8s-02
    config.vm.define "k8s-02" do |k8s_02|
        k8s_02.vm.hostname = "k8s-02.localhost"
        k8s_02.vm.network:private_network, ip:"10.1.0.7"
    end

    # Copy over the host ssh pub key
    config.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
        s.inline = <<-SHELL
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        SHELL
    end
  end
