set ns [new Simulator]
$ns color 0 red
$ns color 1 green
set nf [open out.nam w]
$ns namtrace-all $nf
proc finish {} {
global ns nf
$ns flush-trace
close $nf
exec nam out.nam
exit 0
}
#Creating Nodes
for {set i 0} {$i<5} {incr i} {
set n($i) [$ns node]
}
$n(0) label "A"
$n(1) label "B"
$n(2) label "C"
$n(3) label "D"
$n(4) label "E"
#Creating Links
$ns duplex-link $n(0) $n(1) 512Kb 5ms DropTail
$ns duplex-link $n(1) $n(2) 512Kb 5ms DropTail
$ns duplex-link $n(2) $n(3) 512Kb 5ms DropTail
$ns duplex-link $n(3) $n(4) 512Kb 5ms DropTail
$ns simplex-link $n(4) $n(0) 512Kb 5ms DropTail
#Creating TCP agent and attaching to node 0
set tcp0 [new Agent/TCP]
$ns attach-agent $n(0) $tcp0
#Creating sink and attaching to node 4
set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink
$ns connect $sink $tcp0
#Creating UDP agent and attaching to node 1
set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1
#Creating Null agent and attaching to node 3
set null1 [new Agent/Null]
$ns attach-agent $n(3) $null1
$ns connect $udp1 $null1
$tcp0 set fid_ 1
$udp1 set fid_ 0
#Creating a FTP agent and attaching it to udp0
set ftp0 [new Application/FTP]
$ftp0 set packetSize_ 1024
$ftp0 set interval_ 0.01
$ftp0 attach-agent $tcp0
#Creating a CBR agent and attaching it to udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 1024
$cbr1 set interval_ 0.01
$cbr1 attach-agent $udp1
$ns at 1.0 "$ftp0 start"
$ns at 3.0 "$ftp0 stop"
$ns at 3.0 "$cbr1 start"
$ns at 5.0 "$cbr1 stop"
$ns at 6.0 "finish"
$ns run
