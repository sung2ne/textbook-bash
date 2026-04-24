FROM node:20-alpine

# 작업 디렉토리 설정
WORKDIR /app

# netcat 설치 (wait_for_db에서 nc 명령 사용)
RUN apk add --no-cache netcat-openbsd gettext

# 의존성 먼저 복사 (레이어 캐시 최적화)
COPY package*.json ./
RUN npm install --production

# 앱 소스 복사
COPY . .

# entrypoint 스크립트 복사 및 실행 권한 부여
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 비루트 사용자로 실행 (보안)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "server.js"]