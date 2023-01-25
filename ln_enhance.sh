#!/bin/bash
echo "批量软链接脚本"
#start_path=$1
#end_path=$2
set -x
start_path="$1"
end_path="$2"
start_path="$(echo $start_path|sed -r "s#/\$##g")"
end_path="$(echo $end_path|sed -r "s#/\$##g")"

	OLDIFS="$IFS"  
    IFS=$'\n' 
if [[ $start_path == "" ]] || [[ $end_path == "" ]]
then
	echo "没有输入参数"
	exit
fi
if [[ $(ls  -l "$start_path" | grep -c "^d") -ge 1 ]]
then
    echo "第一級存在文件夹和文件"
    echo "开始链接下面的子文件夹"
	for element in `du -h $start_path`
	do
	  final_path=""
      delete_element="$(echo $element | awk '{print $1}')"
	  element="$(echo $element | sed -r "s#$delete_element##g" | sed -r "s#^[^/]+##")"
	  echo "子文件夹是"$element
	  if [[ $(ls  -l "$element" | grep -c "^d") -ge 1 ]]
	  then
			echo "存在其他文件"
			###路径转换
			final_path="$end_path""$(echo $element | sed -r "s#$start_path##g"|sed -r "s#/\$##g")"  ##sed -r "s#/\$##g" 去掉最后一个/
			echo "路径转换后的路径是""$final_path"
			mkdir -p "$final_path"
			for file in `ls  -l "$element" | grep  "^-"| grep -Eo "[0-9]+:[0-9]+.*"|sed -r "s#[0-9]+:[0-9]+##g"|sed -r "s#^ +##g"`
			do
				echo "$final_path"/"$file"
				ln -s "$element"/"$file"	"$final_path"/"$file"
			done
		    
	  else
	        final_path="$end_path""$(echo $element | sed -r "s#$start_path##g"|sed -r "s#/\$##g")"  ##sed -r "s#/\$##g" 去掉最后一个/
			echo "路径转换后的路径是""$final_path"
			mkdir -p "$final_path"
			echo "不存在其他文件夹"
			ln -s "$element/"*   "$final_path" 
	  fi	  
	done
else
	echo "文件夹下就是我们需要进行操作的文件"
	ln -s "$start_path"/* "$end_path"
fi
IFS=$OLDIFS
set +x