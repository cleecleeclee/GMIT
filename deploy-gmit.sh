#!/usr/bin/env bash
# GMIT 배포 스크립트 — cleecleeclee 계정 인증을 마친 뒤 실행하세요.
#
# 사전 준비(대화형 터미널에서 한 번만):
#   gh auth login                      # GitHub.com > HTTPS > 브라우저 로그인(cleecleeclee)
#   또는 이미 추가했다면:  gh auth switch --user cleecleeclee
#
# 그 다음 이 폴더에서:  bash deploy-gmit.sh

set -euo pipefail

OWNER="cleecleeclee"
REPO="GMIT"

echo "== 현재 gh 계정 확인 =="
CURRENT="$(gh api user --jq .login)"
echo "현재 로그인: $CURRENT"
if [ "$CURRENT" != "$OWNER" ]; then
  echo "!! 현재 계정이 $OWNER 가 아닙니다. 아래로 전환 후 다시 실행하세요:"
  echo "   gh auth switch --user $OWNER   (또는 gh auth login)"
  exit 1
fi

echo "== 저장소 생성 + 푸시 =="
gh repo create "$OWNER/$REPO" --public --source=. --remote=origin --push \
  --description "굿모닝인테리어 홈페이지 초안 (피드백용)"

echo "== GitHub Pages 활성화 (main 브랜치 / 루트) =="
gh api -X POST "repos/$OWNER/$REPO/pages" \
  -f "source[branch]=main" -f "source[path]=/" || \
  echo "(이미 활성화됐거나 잠시 후 다시 시도하세요)"

echo
echo "== 완료 =="
echo "저장소:   https://github.com/$OWNER/$REPO"
echo "공개 URL: https://$OWNER.github.io/$REPO/"
echo "(Pages 최초 빌드는 30초~2분 걸릴 수 있어요.)"
