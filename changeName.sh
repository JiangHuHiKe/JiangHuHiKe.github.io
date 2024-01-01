
#!/bin/bash

# 指定目录
directory="/Users/lxy/LXYFile/ResourceInGithub/JiangHuHiKe/_posts/2023_A_Overview"



start_date="2023-02-01"
current_date=$(date -jf "%Y-%m-%d" "$start_date" "+%Y-%m-%d")

# end_date=$(date "+%Y-%m-%d")
# while [[ "$current_date" < "$end_date" ]]; do
#     echo "$current_date"
#     current_date=$(date -jf "%Y-%m-%d" -v+1d "$current_date" "+%Y-%m-%d")
# done


# 遍历每个文件
find "$directory" -type f -name "????-??-??*.md" -print0 | sort -z | while IFS= read -r -d '' file_full_path
do

    # 一、修改文件名字
    # 使用basename获取文件名部分
    file_date_name=$(basename "$file_full_path")
    # echo "file_date_name=$file_date_name"

    # 文件名中日期部分
    file_date="$current_date"
    # echo "file_date=$file_date"

    # 文件名中名字部分
    # file_name=${file_date_name:10}
    file_name=$(echo "${file_date_name:10}" | sed 's/ //g')
    if [[ "$file_name" != -* ]]; then
        file_name="-${file_name}"
    fi
    # echo "file_name=$file_name"

    # 新的文件名
    new_file_date_name="${file_date}${file_name}"
    # echo "new_file_date_name=$new_file_date_name"

    # 新的文件的绝对路径
    new_file_full_path=${directory}/${new_file_date_name}
    # echo "new_file_full_path=$new_file_full_path"

    # 重命名文件
    mv "$file_full_path" "$new_file_full_path"


    # 二、修改文件内容
    sed -E -i "" "s/date:[[:space:]]*([0-9]{4}-[0-9]{2}-[0-9]{2})/date: ${current_date}/g" $new_file_full_path


    # 三、输出完成日志
    echo "将文件 $file_date_name\n修改为 $new_file_date_name"


    # 四、日期增加一天
    current_date=$(date -jf "%Y-%m-%d" -v+1d "$current_date" "+%Y-%m-%d")
    echo "-----------------------------------\n"
done