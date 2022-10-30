# NS RING
set ns [new Simulator]
$ns color 1 Green
$ns color 2 Red
set nf [open out1.nam w]
$ns namtrace-all $nf
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out1.nam &
	exit 0
}
set A [$ns node]
set B [$ns node]
set C [$ns node]
set D [$ns node]
set E [$ns node]
$ns duplex-link $A $B 1Mb 10ms DropTail
$ns duplex-link $B $C 1Mb 10ms DropTail
$ns duplex-link $C $D 1Mb 10ms DropTail
$ns duplex-link $D $E 1Mb 10ms DropTail
$ns simplex-link $E $A 1Mb 10ms DropTail
set tcp [new Agent/TCP]
$tcp set class_ 2
set sink1 [new Agent/TCPSink]
$ns attach-agent $A $tcp
$ns attach-agent $E $sink1
$ns connect $tcp $sink1
set ftp [new Application/FTP]
$ftp set type_ FTP
$ftp attach-agent $tcp
$tcp set fid_ 1
set tcp1 [new Agent/TCP]
$tcp set class_ 2
set sink2 [new Agent/TCPSink]
$ns attach-agent $B $tcp1
$ns attach-agent $E $sink2
$ns connect $tcp1 $sink2
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 1000
$cbr set type_ CBR
$cbr set rate 1mb
$cbr attach-agent $tcp1
$tcp set fid_ 2
$ns at 1.0 "$ftp start"
$ns at 3.0 "$ftp stop"
$ns at 3.0 "$cbr start"
$ns at 5.0 "$cbr stop"
$ns at 6.0 "finish"
$ns run
