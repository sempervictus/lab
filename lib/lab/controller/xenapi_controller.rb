require 'xenapi-ruby'

# Ignore certs, this needs to get smarter
# Goes into "use Rex for XMLRPC TODO list"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Lab
module Controllers
module XenApiController

  # Get vm UUIDs and pull info hashes
  def self.vm_list_all(user,host,pass,running_only=false)
    s = self.get_xapi_session(user,host,pass)
    vms = []
    s.VM.get_all.map do |vref|
      vm = s.VM.get_record(vref)
      next if vm['is_a_template'] or vm['s_a_snapshot'] or vm['name_label'].match(/^Control domain/)
      vms << vm.merge('vmid' => vref)
    end

    return running_only ? vms.keep_if {|v| v['power_state'] == 'Running'} : vms
  end

  # Get SR UUIDs and pull info hashes
  def self.sr_list_all(user,host,pass)
    s = self.get_xapi_session(user,host,pass)
    return s.SR.get_all.map {|srid| s.SR.get_record(srid)}
  end

  # Compat method wrappers

  def self.running_list(user,host,pass)
    self.vm_list_all(user,host,pass,true)
  end

  def self.config_list
  end

  def self.storage_list
  end

  def self.hosts_list
  end

  def self.dir_list
  end

  private

  def self.get_xapi_session(user,host,pass,port=443)
    begin
      # Try SSL with port
      s = XenAPI::Session.new("https://#{host}:#{port}")
      s.login_with_password(user,pass)
    rescue
      # Miserable HTTP on 80 faildown
      s = XenAPI::Session.new("http://#{host}")
      s.login_with_password(user,pass)
      return s
    end
    # If this is somehow nil we will get upstream errors
    return s
  end

end
end
end
