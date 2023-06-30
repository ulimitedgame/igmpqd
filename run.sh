
cmd="$1"
dst_group_ip="$2"

if [ "$cmd" = "clean" ];then
    make clean
    exit 0
elif [ "$cmd" = "make" ];then
    make
    exit 0
fi

if [ -z "$dst_group_ip" ];then
    dst_group_ip="224.0.0.1"
fi

bin="bin/linux/amd64/go-igmpqd"
if [ ! -f "$bin" ];then
    make 
fi

sudo $bin run --debug  -I enp4s0 -d $dst_group_ip -i 30 -t 1 -m 100


# efault         10.223.40.254   0.0.0.0         UG    103    0        0 enp4s0
# 10.223.40.0     0.0.0.0         255.255.255.0   U     103    0        0 enp4s0
# link-local      0.0.0.0         255.255.0.0     U     1000   0        0 eno1
# 172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
# 172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 br-982ed977d9e0
# 192.168.0.0     0.0.0.0         255.255.0.0     U     0      0        0 eno1
# 192.168.1.0     0.0.0.0         255.255.255.0   U     102    0        0 eno1
# > sudo bin/linux/amd64/go-igmpqd run -h
# Usage:
#   igmpqd run [flags]

# Flags:
#       --debug                 Enable debug messages to stderr.
#   -d, --dstAddress string     Specified IP address to send the IGMP Query to. (default "224.0.0.1")
#   -g, --grpAddress string     Specified IP address to use as the Group Address. Used to query for specific group members. (default "0.0.0.0")
#   -h, --help                  help for run
#   -I, --interface string      Specified network interface to send the IGMP Query.
#   -i, --interval int          The time in seconds to delay between sending IGMP Query messages. (default 30)
#   -m, --maxResponseTime int   Specifies the maximum allowed time before sending a responding report in units of 1/10 second. (default 100)
#   -t, --ttl int               The TTL of the IGMP Query. (default 1)