#!/bin/bash

# 自动更新插件导出文件
# 扫描 lib/src/ 目录下的所有 .dart 文件，并自动添加到主导出文件中

set -e

# 获取脚本所在目录的父目录（项目根目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 切换到项目根目录
cd "$PROJECT_ROOT"

# ========== 配置区域 ==========

# 插件名称（从目录名获取）
PLUGIN_NAME=$(basename "$PROJECT_ROOT")

# 排除的文件模式（不会被导出）
exclude_patterns=(
    "_*"              # 私有文件（以 _ 开头）
    "*.g.dart"        # JSON 序列化生成文件
    "*.freezed.dart"  # Freezed 生成文件
    "*.mocks.dart"    # Mock 生成文件
    "*.gr.dart"       # AutoRoute 生成文件
)

# ========== 配置区域结束 ==========

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 开始更新 $PLUGIN_NAME 插件导出文件...${NC}"
echo ""

# 检查是否是 Flutter 插件
if [ ! -f "$PROJECT_ROOT/pubspec.yaml" ]; then
    echo -e "${RED}❌ 未找到 pubspec.yaml，请确保在 Flutter 插件目录中运行${NC}"
    exit 1
fi

# 主导出文件路径
MAIN_FILE="$PROJECT_ROOT/lib/$PLUGIN_NAME.dart"
SRC_DIR="$PROJECT_ROOT/lib/src"
LIB_DIR="$PROJECT_ROOT/lib"

# 确定扫描目录
if [ -d "$SRC_DIR" ]; then
    SCAN_DIR="$SRC_DIR"
    echo -e "${GREEN}📂 扫描目录: lib/src/${NC}"
else
    SCAN_DIR="$LIB_DIR"
    echo -e "${GREEN}📂 扫描目录: lib/${NC}"
fi

# 从 pubspec.yaml 中读取插件描述
DESCRIPTION=""
if [ -f "$PROJECT_ROOT/pubspec.yaml" ]; then
    DESCRIPTION=$(grep "^description:" "$PROJECT_ROOT/pubspec.yaml" | sed 's/^description: *//' | sed 's/^["'\'']//' | sed 's/["'\'']$//')
fi

# 如果没有描述，使用默认描述
if [ -z "$DESCRIPTION" ]; then
    DESCRIPTION="$PLUGIN_NAME plugin"
fi

# 创建临时文件
TEMP_FILE=$(mktemp)

# 插件名称格式化（首字母大写）
PLUGIN_NAME_FORMATTED=$(echo "$PLUGIN_NAME" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1')

# 写入文件头
cat > "$TEMP_FILE" << EOF
/// $PLUGIN_NAME_FORMATTED
///
/// $DESCRIPTION

library $PLUGIN_NAME;

EOF

# 构建 find 命令的排除参数
FIND_CMD="find \"$SCAN_DIR\" -name \"*.dart\" -type f"
for pattern in "${exclude_patterns[@]}"; do
    FIND_CMD="$FIND_CMD ! -name \"$pattern\""
done
# 排除主文件本身
FIND_CMD="$FIND_CMD ! -path \"$MAIN_FILE\""
FIND_CMD="$FIND_CMD | sort"

# 查找所有 .dart 文件
DART_FILES=$(eval $FIND_CMD)

if [ -z "$DART_FILES" ]; then
    echo -e "${YELLOW}⚠️  未找到可导出的文件${NC}"
    rm "$TEMP_FILE"
    exit 0
fi

# 统计文件数量
FILE_COUNT=$(echo "$DART_FILES" | wc -l | tr -d ' ')

echo -e "${GREEN}📄 找到 $FILE_COUNT 个文件${NC}"
echo ""

# 按目录分组导出
CURRENT_DIR=""
HAS_EXPORTS=false

while IFS= read -r file; do
    # 获取相对于 lib/ 的路径
    REL_PATH=${file#$PROJECT_ROOT/lib/}

    # 获取文件所在目录
    FILE_DIR=$(dirname "$REL_PATH")

    # 如果目录改变，添加注释
    if [ "$FILE_DIR" != "$CURRENT_DIR" ]; then
        if [ "$HAS_EXPORTS" = true ]; then
            echo "" >> "$TEMP_FILE"
        fi

        if [ "$FILE_DIR" = "src" ] || [ "$FILE_DIR" = "." ]; then
            echo "// Core" >> "$TEMP_FILE"
        else
            DIR_NAME=$(basename "$FILE_DIR")
            FORMATTED_NAME=$(echo "$DIR_NAME" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1')
            echo "// $FORMATTED_NAME" >> "$TEMP_FILE"
        fi

        CURRENT_DIR="$FILE_DIR"
        HAS_EXPORTS=true
    fi

    # 添加导出语句
    echo "export '$REL_PATH';" >> "$TEMP_FILE"

done <<< "$DART_FILES"

# 确保 lib 目录存在
mkdir -p "$LIB_DIR"

# 比较文件是否有变化
if [ -f "$MAIN_FILE" ] && cmp -s "$TEMP_FILE" "$MAIN_FILE"; then
    echo -e "${GREEN}✓ 无变化${NC}"
    rm "$TEMP_FILE"
else
    mv "$TEMP_FILE" "$MAIN_FILE"
    echo -e "${GREEN}✅ 已更新 $MAIN_FILE${NC}"
    echo ""
    echo -e "${BLUE}导出内容:${NC}"
    cat "$MAIN_FILE"
fi

echo ""
echo -e "${GREEN}✅ 完成！${NC}"