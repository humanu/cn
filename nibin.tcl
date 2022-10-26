set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace 
	close $nf
	exec nam out.nam &
	exit 0
}

$ns color 1 red 
$ns color 2 blue

set n1 [$ns node ]
set n2 [$ns node]

$ns duplex-link $n1 $n2 2Mb 10ms DropTail

set tcp1 [new Agent/TCP]
$tcp1 set fid_ 1
$ns attach-agent $n1 $tcp1

set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $sink2

set tcp2 [new Agent/TCP]
$tcp2 set fid_ 2
$ns attach-agent $n2 $tcp2

set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2

$ns at 0.1 "$ftp1 start"
$ns at 1.0 "$ftp1 stop"
$ns at 1.1 "$ftp2 start"
$ns at 2.0 "$ftp2 stop"
$ns at 3.0 "finish"

$ns run


