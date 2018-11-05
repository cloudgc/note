#!/usr/bin/env bash
ldd /etc/alternatives/jre_1.8.0_openjdk/bin/*  |grep "=> /" | awk 'BEGIN{print "#!/bin/sh"} {print "cp "$3" ./"}'
ldd /etc/alternatives/jre_1.8.0_openjdk/bin/*  |grep "=> /" | awk '{print  $3 }'

ldd /etc/alternatives/jre_1.8.0_openjdk/lib/jexec

#don`t forgotten the soft——link
