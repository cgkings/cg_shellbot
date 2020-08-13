#!/bin/bash
source /root/fclone_shell_bot/myfc_config.ini
# ★★★开启sa服务-已完成★★★
open_sa_server() {
    sumsa=0
    for saf_id in $(sort -u $safolder/invalid/*.json | grep "project_id" | awk '{print $2}' | tr -d ',"')
    do
    cd /root/AutoRclone && python3 gen_sa_accounts.py --enable-services $saf_id
    sumsa=$((sumsa+1))
    echo -e "已开启 第"$sumsa"个sa；共"$sum_check"个sa"
    done
}

stty erase '^H'
echo 读取myfc_config.ini,注意你的CPU负载！
echo -e "你的remote:$fclone_name"
echo -e "你的sa保存目录:$safolder"
echo -e "你的sa检测目标文件夹id:$fsa_id"
echo -e "开启sa服务所需的gen_sa_accounts.py文件所在目录：$pyfolder"
echo -e "以上如需修改，请打开ini文件修改fclone_name\safolder\pyfolder\fsa_id数值"
echo -e "检测NG.文件目录：$safolder/invalid"
echo -e "检测ok文件将移至：/root/AutoRclone/$fclone_name，如需更改，请修改本脚本相应目录行即可"
mkdir -p $safolder/invalid
sa_sum=$(ls -l $safolder|grep "^-"| wc -l)
echo -e "待检测sa $sa_sum 个，开始检测"
find $safolder -type f -name "*.json" | xargs -I {} -n 1 -P 10 bash -c 'fclone lsd '$fclone_name':{1w-AqIaSU2zVG9N7ia_oNPB4qJrCOUQYG} --drive-service-account-file={} --drive-service-account-file-path=""  &> /dev/null || mv -f {'$fsa_id'} '$safolder'/invalid '
xsa_sum=$(ls -l $safolder/invalid|grep "^-"| wc -l)
sa_sum=$(ls -l $safolder|grep "^-"| wc -l)
if [ x$xsa_sum = x0 ];then
echo 恭喜你！你的sa[$sa_sum]全部检测ok！
mv $safolder/*.json /root/AutoRclone/"$fclone_name"
echo -e "检测ok sa已移至/root/AutoRclone/$fclone_name"
elif [ x$sa_sum = x0 ];then
echo 非常遗憾，$sa_sum 个sa,竟然没有一个是ok的，没关系，即将为你开启服务
open_sa_server
else
mv $safolder/*.json /root/AutoRclone/"$fclone_name"
echo -e "检测ok sa $sa_sum 个，已移至/root/AutoRclone/$fclone_name"
echo -e "检测完毕，异常sa $xsa_sum 个,即将为你开启服务！！！"
open_sa_server
fi
echo -e "done！！！"