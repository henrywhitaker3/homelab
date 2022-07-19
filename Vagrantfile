Vagrant.configure("2") do |config|
    config.vm.box = "generic/ubuntu2004"

    config.ssh.insert_key = false

    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.provider :libvirt do |libvirt|
      libvirt.cpus = 2
      libvirt.memory = 512
    end

    # App server
    config.vm.define "docker-v" do |docker|
      docker.vm.hostname = "docker-v.localhost"
      docker.vm.network:private_network, ip:"10.1.0.2"
    end

    # Copy over the host ssh pub key
    config.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
        s.inline = <<-SHELL
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        SHELL
    end
  end
