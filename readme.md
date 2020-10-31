# 自动助教发邮箱的脚本

## 原理

基于smtp，首先复制一份原始文件并改名，然后打包，然后发送给助教的脚本
时间：默认上一个周四，如果是周四的话会有额外的提示

## 用法

### 编辑info.json

```[json]
{
    "name": "名字",
    "id": "学号",
    "lessonTime": "910 或者 78",
    "emailFrom": "你的邮箱",
    "emialTo": "助教邮箱",
    "smtp": "smtp服务器地址，比如smtp.tongji.edu.cn"
}
```

### 使用
打开powershell众终端

```[shell]
    send_mail.ps1 -f  <filename1>, <filename2>, <filename3>... -e <experiment1>, <experiment2>, <experiment3>...
```
> filenameX：报告原始文件名，如.\a.docx
> experimentX：序号和实验名，如7vlan配置实验

然后输入邮箱密码即可

## 问题

乱码：本脚本，为了方便在windows平台使用，使用GBK编码，如果当前终端为其他编码，请使用`dhcp 936`切换