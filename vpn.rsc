# Script of VPN connection error handler
# Script uses ideas by EdkiyGluk
# https://github.com/drpioneer/MikrotikCheckVPN/blob/main/vpn.rsc
# http://forummikrotik.ru/viewtopic.php?f=14&t=6258
# tested on ROS 6.49.10
# updated 2024/03/19

:do {
  :local nameVPN "VPN"; :local cntPing 3; :local msg "";
  :put "Start of VPN connection error handler script on router: $[/system identity get name]";
  :if ([/interface find name~$nameVPN]!="") do={
    /interface set [find name~$nameVPN disabled=yes] disabled=no; /delay delay-time=7s;
    /ip address;
    :foreach actVPN in=[find interface~$nameVPN] do={
      :do {
        :local ifcVPN [get $actVPN interface]; :local adrVPN [get $actVPN address];
        :local netVPN [get $actVPN network]; :local locAdr [:pick $adrVPN 0 [:find $adrVPN "/"]];
        :local chkPng [/ping $netVPN src-address=$locAdr count=$cntPing];
        :if (($chkPng*10)<($cntPing*10>>2)) do={
          /interface disable $ifcVPN; /delay delay-time=3s; /interface enable $ifcVPN;
          :set msg "$msg\r\n>>> $ifcVPN reactivated"; /log info ">>> $ifcVPN reactivated";
        } else={:set msg "$msg\r\n>>> $ifcVPN ($locAdr<->$netVPN) is connected"}
      } on-error={
        :set msg "$msg\r\nError, working VPN not found"; /log warning "Error, working VPN not found"}}
  } else={:set msg "$msg\r\nVPN '$nameVPN' not found"; /log warning "VPN '$nameVPN' not found"}
  :put $msg; 
}
