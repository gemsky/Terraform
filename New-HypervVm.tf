# Make sure you have the Hyper-V provider installed and configured in your Terraform environment. Adjust the values of the provider and resources as needed for your specific environment.
# In this Terraform code, each PowerShell command is mapped to a corresponding resource from the Hyper-V provider. The resource names and properties match the PowerShell commands and parameters. 
# The hyperv_virtual_machine resource represents the virtual machine, and other resources such as hyperv_vm_memory, hyperv_vm_processor, hyperv_virtual_hard_disk, hyperv_vm_network_adapter, hyperv_vm_firmware, and hyperv_vm_state configure various aspects of the virtual machine.
# After writing the Terraform code, you can use terraform init, terraform plan, and terraform apply commands to initialize, validate, and create the virtual machine in Hyper-V based on the Terraform configuration.
# Please note that the Terraform code provided here assumes you have the required permissions and access to the Hyper-V environment. Adjust the code as necessary to match your specific configuration and environment.

# Terraform code to create a virtual machine in Hyper-V
provider "hyperv" {
  server = "VMHOST"  # Update with the Hyper-V server address if needed
}

resource "hyperv_virtual_machine" "my_vm" {
  name       = "VMTest1"
  path       = "D:\\Hyper-V\\Virtual Hard Disks"
  generation = 2
}

resource "hyperv_vm_memory" "my_vm_memory" {
  vm_name        = hyperv_virtual_machine.my_vm.name
  startup_bytes  = "4GB"
}

resource "hyperv_vm_processor" "my_vm_processor" {
  vm_name = hyperv_virtual_machine.my_vm.name
  count   = 2
}

resource "hyperv_virtual_hard_disk" "my_vm_disk" {
  path     = "${hyperv_virtual_machine.my_vm.path}\\${hyperv_virtual_machine.my_vm.name}.vhdx"
  size     = "127GB"
  disk_type = "dynamic"
}

resource "hyperv_vm_hard_disk_drive" "my_vm_hdd" {
  vm_name = hyperv_virtual_machine.my_vm.name
  path    = hyperv_virtual_hard_disk.my_vm_disk.path
}

resource "hyperv_vm_network_adapter" "my_vm_adapter" {
  vm_name      = hyperv_virtual_machine.my_vm.name
  switch_name  = "My_LAN"
}

resource "hyperv_vm_firmware" "my_vm_firmware" {
  vm_name          = hyperv_virtual_machine.my_vm.name
  first_boot_device = hyperv_vm_network_adapter.my_vm_adapter.id
  enable_secure_boot = false
}

resource "hyperv_vm_state" "my_vm_state" {
  vm_name = hyperv_virtual_machine.my_vm.name
  state   = "running"
}
