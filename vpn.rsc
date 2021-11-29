# Script VPN connection error handler by EdkiyGluk
# http://forummikrotik.ru/viewtopic.php?f=14&t=6258
# tested on ROS 6.48.3
# updated 2021/06/24

:do {
    :local nameVPN      "VPN";
    :local countPing    3;
    :local message      "Getting start the script of VPN connection error handler.\r\n";
    if ([ /interface find name~$nameVPN; ] != "") do={
        /interface set [ /interface find name~$nameVPN disabled=yes; ] disabled=no;
        :foreach activeVPN in=[ /ip address find interface~$nameVPN; ] do={
            :do {
                :local remoteAddress [ /ip address get $activeVPN network; ];
                :local localAddress  [ :pick [ /ip address get $activeVPN address; ] 0 ([ :len [ /ip address get $activeVPN address; ]] - 3)];
                :local interfaceVPN  [ /ip address get $activeVPN interface; ];
                :local checkPing     [ /ping $remoteAddress src-address=$localAddress count=$countPing; ];
                :if (($checkPing * 10) < ($countPing * 10 / 4)) do={
                    /interface disable $interfaceVPN;
                    delay delay-time=3s;
                    /interface enable $interfaceVPN;
                    :log info             ("VPN interface $interfaceVPN reactivated.");
                    :set message ("$message VPN interface $interfaceVPN reactivated.\r\n");
                } else={
                    :set message ("$message VPN interface $interfaceVPN is working.\r\n");
                }
            } on-error={
                :log warning          ("Script error. Working VPN interface not found.");
                :set message ("$message Script error. Working VPN interface not found.");
            }
        }
    } else={ 
        :log warning          ("VPN interface '$nameVPN' not found."); 
        :set message ("$message VPN interface '".$nameVPN."' not found.\r\n"); 
    }
    :put ($message."Termination of the VPN connection error handler."); 
}
