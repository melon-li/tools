#!/bin/bash
dockers=(4f45cf7d2c20 36b58a9b6b46 718214206cd2 18a5496a6051 7e0da447b710 308942b3bfa2 f2ee904667d3 81e218147653 69e1de4ff774 13cfe9393da6 d3a2e3d8e7a7 d1b20d7069bc 9ed3cf2607ed b3943c90274c c16ea166982e fb4a57b4d88b f53705edebf1 d8513cdcc7e5 aba049acc4be 5a6fb436a750 1a2aa4531a28 f9433cec5c8e 1ddf183f1611 bea01a45124d ad2a56bec3b8 0321b0d43041 7661bbfaad0c b3a709be47ec e77b53a808a8 e2922e7650e7 f44373d9a22a 1d700cc5b650 c7e13133d6c4 df70e3a3e824 6e12fd225500 b5a9b1467a8b 58427af3fb44 cc71cfeacbd4 0f41ba9d7661 5db4e57d9a55 0d7392a7a6ca eb821d39b0be da07be8ad7f3 455713737bec 06d34cbc2e95 c840dec7899f c88e6692fc0a 5b3ff0a6d847 7bd5e4f341bb 7dbc7f3d1ed7 0ef8437551ff b1631e370038 2979bd23e015 3a3165918690 c38d5c5dd66b 2104419efde6)
names=()
for d in `echo ${dockers[*]}`
do
    name=`docker exec $d hostname`
    docker exec $d cat "/tmp/log_count.""$name" &
#    docker exec $d iptables -L &
    index=${#names[*]}
    names[$index]=$name
done
#echo ${names[*]}
