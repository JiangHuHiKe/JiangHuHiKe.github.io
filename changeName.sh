#!/bin/bash

# 指定目录
directory="/Users/lixiaoyi/LXYFile/ResourceInGithub/JiangHuHiKe.github.io/_posts/2015_B_CodeEncrypt"
# directory="/Users/lxy/LXYFile/ResourceInGithub/JiangHuHiKe/_posts/2024_A_Harmony"

# 遍历文件夹下文件时，跳过前面几个文件的个数
skipCount=0

# 开始日期
start_date="2015-06-01"
current_date=$(date -jf "%Y-%m-%d" "$start_date" "+%Y-%m-%d")

# 遍历每个文件
find "$directory" -type f -name "????-??-??*.md" -print0 | sort -z | {

    # 记录遍历过的文件个数
    counter=0

    while IFS= read -r -d '' file_full_path; do
        # Increment the counter for each file
        ((counter++))

        # Skip the first four files
        if [[ $counter -le skipCount ]]; then
            continue
        fi

        # 一、修改文件名字
        # 使用basename获取文件名部分
        file_date_name=$(basename "$file_full_path")

        # 文件名中日期部分
        file_date="$current_date"

        # 文件名中名字部分
        file_name=$(echo "${file_date_name:10}" | sed 's/ //g')
        if [[ "$file_name" != -* ]]; then
            file_name="-${file_name}"
        fi

        # 新的文件名
        new_file_date_name="${file_date}${file_name}"

        # 新的文件的绝对路径
        new_file_full_path="${directory}/${new_file_date_name}"

        # 重命名文件
        mv "$file_full_path" "$new_file_full_path"

        # 二、修改文件内容
        sed -E -i "" "s/date:[[:space:]]*([0-9]{4}-[0-9]{2}-[0-9]{2})/date: ${current_date}/g" "$new_file_full_path"

        # 三、输出完成日志
        echo "将文件 $file_date_name\n修改为 $new_file_date_name"

        # 四、日期增加一天
        current_date=$(date -jf "%Y-%m-%d" -v+1d "$current_date" "+%Y-%m-%d")
        echo "-----------------------------------\n"
    done
}
