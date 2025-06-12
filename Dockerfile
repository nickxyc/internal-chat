FROM node:16-alpine

# 安装 Nginx 和 supervisord
RUN apk add --no-cache nginx supervisor

# 设置中国 npm 镜像
RUN npm config set registry https://registry.npmmirror.com

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 安装依赖
RUN npm ci --production

# 创建运行所需目录
RUN mkdir -p /run/nginx /var/log/supervisor

# 拷贝 nginx 配置文件
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# 拷贝 supervisor 配置
COPY supervisord.conf /etc/supervisord.conf

# 拷贝房间密码配置（或用 volume 替代）
COPY room_pwd.json /app/room_pwd.json

# 暴露外部端口（由 Nginx 提供访问入口）
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
