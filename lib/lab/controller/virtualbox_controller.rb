module Lab
module Controllers
module VirtualBoxController

  def self.running_list
    vm_names_and_uuids = `VBoxManage list runningvms`
    return vm_names_and_uuids.scan(/\"(.*)\" {.*}/).flatten
  end

  def self.config_list
    vm_names_and_uuids = `VBoxManage list vms`
    return vm_names_and_uuids.scan(/\"(.*)\" {.*}/).flatten
  end

  def self.config_list_uuid
    vm_names_and_uuids = `VBoxManage list vms`
    return vm_names_and_uuids.scan(/\".*\" {(.*)}/).flatten
  end

  def self.dir_list(basepath=nil)
    vm_list = Find.find(basepath).select { |f| f =~ /\.xml$/ }
  end

  def self.get_vms
    vm_names_and_uuids = `VBoxManage list vms`
    return vm_names_and_uuids.scan(/\"(.*)\" {.*}/).flatten
  end
end
end
end
