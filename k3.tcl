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
set a [$ns node]
set b [$ns node]
set c [$ns node]
set d [$ns node]
set e [$ns node]

$ns color 0 green
$ns color 1 red

$ns simplex-link $a $b 2Mb 10ms DropTail
$ns simplex-link $b $c 2Mb 10ms DropTail
$ns simplex-link $c $d 2Mb 10ms DropTail
$ns simplex-link $d $e 2Mb 10ms DropTail
$ns simplex-link $e $a 2Mb 10ms DropTail



set udp0 [new Agent/UDP]
$udp0 set class_ 1
$udp0 set fid_ 1
$ns attach-agent $b $udp0


set tcp0 [new Agent/TCP]
$tcp0 set class_ 0
$tcp0 set fid_ 0
$ns attach-agent $a $tcp0


set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set null0 [new Agent/Null]
$ns attach-agent $d $null0

set sink0 [new Agent/TCPSink]
$ns attach-agent $e $sink0

$ns connect $tcp0 $sink0
$ns connect $udp0 $null0
$ns at 1.0 "$ftp0 start"
$ns at 3.0 "$ftp0 stop"
$ns at 3.0 "$cbr0 start"
$ns at 5.0 "$cbr0 stop"
$ns at 5.0 "finish"

$ns run
