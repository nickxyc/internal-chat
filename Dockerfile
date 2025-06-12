# 第一阶段：构建阶段
FROM node:16-alpine AS builder

# 设置 npm 镜像为淘宝源（npmmirror）
RUN npm config set registry https://registry.npmmirror.com

# 设置工作目录
WORKDIR /app

# 拷贝依赖定义文件
COPY package*.json ./

# 安装依赖（使用淘宝镜像）
RUN npm ci --production

# 拷贝全部代码
COPY . .

# 第二阶段：精简运行镜像
FROM node:16-alpine

# 设置 npm 镜像为淘宝源
RUN npm config set registry https://registry.npmmirror.com

# 设置工作目录
WORKDIR /app

# 拷贝依赖和项目代码
COPY --from=builder /app /app

# 暴露默认端口
EXPOSE 8081

# 设置默认环境变量
ENV PORT=8081

# 启动应用
CMD ["sh", "-c", "exec npm run start $PORT"]
