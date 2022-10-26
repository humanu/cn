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

$ns duplex-link $a $b 2Mb 10ms DropTail
$ns duplex-link $c $b 2Mb 10ms DropTail
$ns duplex-link $d $b 2Mb 10ms DropTail
$ns duplex-link $e $b 2Mb 10ms DropTail



set udp0 [new Agent/UDP]
$udp0 set class_ 1
$udp0 set fid_ 1
$ns attach-agent $b $udp0

set udp1 [new Agent/UDP]
$udp1 set class_ 0
$udp1 set fid_ 0
$ns attach-agent $b $udp1

set udp2 [new Agent/UDP]
$udp2 set class_ 1
$udp2 set fid_ 1
$ns attach-agent $b $udp2

set udp3 [new Agent/UDP]
$udp3 set class_ 1
$udp3 set fid_ 1
$ns attach-agent $b $udp3


set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 1000
$cbr2 set interval_ 0.005
$cbr2 attach-agent $udp2

set cbr3 [new Application/Traffic/CBR]
$cbr3 set packetSize_ 1000
$cbr3 set interval_ 0.005
$cbr3 attach-agent $udp3


set null0 [new Agent/Null]
set null1 [new Agent/Null]
set null2 [new Agent/Null]
set null3 [new Agent/Null]
$ns attach-agent $d $null0
$ns attach-agent $c $null1
$ns attach-agent $e $null2
$ns attach-agent $a $null3


$ns connect $udp0 $null0
$ns connect $udp1 $null1
$ns connect $udp2 $null2
$ns connect $udp3 $null3

$ns at 2.0 "$cbr0 start"
$ns at 5.0 "$cbr0 stop"

$ns at 2.0 "$cbr1 start"
$ns at 5.0 "$cbr1 stop"

$ns at 2.0 "$cbr2 start"
$ns at 5.0 "$cbr2 stop"

$ns at 2.0 "$cbr3 start"
$ns at 5.0 "$cbr3 stop"



$ns at 5.0 "finish"

$ns run
