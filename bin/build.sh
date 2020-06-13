#!/bin/bash

BASE_DIR="$(dirname "$0")/.."

DOCS_DIR_NAME="docs"
DOCS_WORKSPACE="${BASE_DIR}/${DOCS_DIR_NAME}"
BUILD_WORKSPACE="${BASE_DIR}/build"
VUE_PRESS_DIR="$DOCS_WORKSPACE/.vuepress"
DIST_DIR="$VUE_PRESS_DIR/dist"

# api文档路径
API_SIET_DOC_PATH="docs/party-api"

# 修正PATH环境变量未设置导致的命名查找失败
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# 删除旧的工作空间
rm -rf $DOCS_WORKSPACE $BUILD_WORKSPACE

# 创建BUILD工作空间
mkdir $BUILD_WORKSPACE


# Clone docs仓库
# 使用GitLab Deploy Token
PROJECT_DOCS_DIR="${BUILD_WORKSPACE}"

git clone --depth=1 --branch=master \
    https://gitee.com/ShixiangWang/Cookbook-for-R-Chinese.git $PROJECT_DOCS_DIR

# 构建DOCS工作空间
mkdir $DOCS_WORKSPACE

# 解决npm下载慢的问题
alias npm="npm --registry=https://registry.npm.taobao.org \
    --cache=$HOME/.npm/.cache/cnpm \
    --disturl=https://npm.taobao.org/dist \
    --userconfig=$HOME/.cnpmrc"

# 修正vuepress命名查找不到的问题
if ! [ -x "$(command -v vuepress)" ]; then
    npm install -g vuepress
fi
if [ ! -d "${BASE_DIR}/node_modules/@vuepress" ]; then
    npm install vuepress
fi

cp -a vuepress $VUE_PRESS_DIR

cp -a $PROJECT_DOCS_DIR/* "${DOCS_WORKSPACE}/"

# 生成侧边栏
node bin/gen-sidebar.js "${DOCS_DIR_NAME}/" > "${VUE_PRESS_DIR}/sidebar.js"

LAST_COMPILE_TIME="$(date '+%Y-%m-%d %H:%M:%S')"
sed -i "s/{{LastCompileTime}}/${LAST_COMPILE_TIME}/g" "${VUE_PRESS_DIR}/compile.js"

# 生成SPA应用
for ((i=0;i<5;i++)); do
    npm run docs:build
    if [[ $? -eq 0 ]]; then
        ls -l $DIST_DIR
        break
    fi

    # 有些时候会出现模块缺失导致build失败
    npm install
done

rm -rf "${PROJECT_DOCS_DIR}/.git" "${PROJECT_DOCS_DIR}/$API_SIET_DOC_PATH/.git"