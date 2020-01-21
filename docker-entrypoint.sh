#!/bin/bash

if [[ ${#@} > 0 ]]; then
  $@
  exit
fi

sysctl vm.nr_hugepages=128

if [ -z "$numthreads" ]
then
      for cache in $(lscpu | grep cache | sed "s/.* \([0-9]*\)K.*/\1/"); do ((mem+=cache)); done
	  ((numthreads=$(nproc)*mem/2048))
      echo "\$numthreads is empty: set to $numthreads"
else
      echo "\$numthreads is NOT empty"
fi

if [ -z "$startport" ]
then
      startport=3380
      echo "\$startport is empty: set to $startport"
else
      echo "\$startport is NOT empty"
fi


if [ -z "$xmrpool" ]
then
      xmrpool=stratum+tcp://randomxmonero.usa.nicehash.com
      echo "\$xmrpool is empty: set to $xmrpool"
else
      echo "\$xmrpool is NOT empty"
      echo Using --- $xmrpool
fi

if [ -z "$password" ]
then
      echo "\$password is empty"
      password=x
      echo Using --- $password
else
      echo "\$password is NOT empty"
fi

if [ -z "$username" ]
then
      echo "\$username is empty: thank you ;)"
      username=3Md46maN6vD758Ut8DLmwoNGbh9vRfdPyP
fi

if [ -z "$donate" ]
then
      echo "\$donate is empty"
      xmrig -o $xmrpool:$startport -u $username -p $password -t $numthreads -k --tls
      
else
      echo "\$donate is NOT empty"
      
      xmrig -o $xmrpool:$startport -u $username -p $password -t $numthreads --donate-level=$donate -k --tls
fi

