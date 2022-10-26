set ns [new Simulator]
set nf [open out1.nam w]
$ns namtrace-all $nf

proc finish {} {
        global ns nf
        $ns flush-trace
        close $nf
        exec nam out1.nam &
        exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$ns color 0 blue
$ns color 1 red

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail


set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$tcp0 set fid_ 1
$ns attach-agent $n0 $tcp0


set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set null0 [new Agent/Null]
$ns attach-agent $n3 $null0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

$ns connect $tcp0 $sink0
$ns connect $udp0 $null0
$ns at 0.5 "$cbr0 start"
$ns at 2.5 "$cbr0 stop"
$ns at 3.0 "$ftp0 start"
$ns at 4.5 "$ftp0 stop"
$ns at 5.0 "finish"

$ns run
