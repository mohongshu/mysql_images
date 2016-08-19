FROM centos:7
MAINTAINER mo.hongshu@163.com

#安装epel-release源
RUN yum install epel-release -y
#安装supervisor
RUN yum install python-setuptools -y
RUN easy_install supervisor
#安装mariadb
ADD ./mariadb-server-5.5.44-2.rpm /
RUN yum localinstall /mariadb-server-5.5.44-2.rpm -y
RUN rm -rf /mariadb-server-5.5.44-2.rpm
#初始化mariadb
RUN mysql_install_db --user=mysql
#设置时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone
#暴露通讯端口
EXPOSE 3306
#环境变量
ENV TERM=dumb
#常驻进程supervisor的配置
ADD ./supervisord.conf /etc/supervisord.conf
#容器启动时执行
CMD supervisord -c /etc/supervisord.conf
