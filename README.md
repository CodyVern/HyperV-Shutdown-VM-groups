# HyperV-Shutdown-VM-groups

Usage situation:
This script is best for systems that have many VM's that have dependencies on each other
across multiple servers

Script description:
The script contains a Function that will verify the presence of VMs across multiple servers then proceed to
shut them down, not ending the function or proceeding to the the next fucntion until all the vm's are in the OFF state.

User Input:
The input for the function is an array of vm names with $servers variable defined outside the function scope
for all servers that contain groups.



