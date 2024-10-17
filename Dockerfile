FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i "s/archive.ubuntu.com/mirrors.lzu.edu.cn/g" /etc/apt/sources.list && apt-get update && apt-get install -y \
    openssh-server \
	sudo \
	net-tools \
	vim \
	cron \
	build-essential



# 配置 SSH 服务
RUN mkdir /var/run/sshd && \
    echo 'root:root123456' | chpasswd

RUN useradd -m -s /bin/bash zhangsan && \
    echo 'zhangsan:123456' | chpasswd


# 允许 SSH 远程登录
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config


# 配置suid提权https://gtfobins.github.io/
RUN chmod u+s /usr/bin/find 
# 配置sudo提权
RUN echo "zhangsan ALL=(ALL) NOPASSWD: /bin/bash" >> /etc/sudoers
# 配置计划任务提权
RUN chmod o+w /etc/crontab
# 配置错误权限
RUN chmod o+w /etc/passwd
# 配置环境变量
COPY ./demo.c /tmp/demo.c
RUN cd /tmp && gcc demo.c -o shell && chmod u+s shell

EXPOSE 22

CMD ["service", "ssh", "start", "-D"]
