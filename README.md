# 📘 shinProject

## 📌 요약

- 하나의 VM(가상서버)에서 두 개의 도메인을 운영하는 구조
- nginx를 이용한 도메인 별 HTTPS 처리 및 리버스 프록시
- 동일한 WAR 프로젝트를 포트별로 분리하여 서비스 인스턴스 운영
- certbot을 이용한 인증서 자동 갱신
- PostgreSQL DB 및 Tomcat 기반 WAS 구성

---

## 🖥️ 시스템 구성 개요

```
HOST MACHINE (Linux VM)
├── nginx (HTTPS 및 리버스 프록시)
│   ├── www.shinwon.site → localhost:8080
│   └── www.cmtech.site  → localhost:8180
│
├── imageproxy (CDN 이미지 최적화)
│   └── /cdn/ 경로 처리
│
├── WAS 인스턴스 (Tomcat)
│   ├── 8080 포트 : shinwon 서비스
│   └── 8180 포트 : cmtech 서비스
│
└── PostgreSQL DB
    ├── cms_shin
    └── cms_cmtech
```

---

## 1. OS 정보 확인

```bash
cat /etc/os-release
```
- Rocky Linux 9.5 (Blue Onyx)

---

## 2. WEB 구성 (nginx + certbot)

### ✅ nginx 설치 및 설정
```bash
dnf install -y nginx
systemctl enable nginx
systemctl start nginx
```

### ✅ certbot을 통한 HTTPS 인증서 발급
```bash
dnf install -y epel-release

dnf install -y certbot python3-certbot-nginx

certbot --nginx -d www.shinwon.site -d www.cmtech.site
```

### ✅ 인증서 자동 갱신 등록
```bash
echo "0 3 * * * root /usr/bin/certbot renew --quiet" >> /etc/crontab
certbot renew --dry-run
```

---

## 3. DB 구성 (PostgreSQL 16)

### ✅ 설치 및 초기화
```bash
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/.../pgdg-redhat-repo-latest.noarch.rpm
sudo dnf -qy module disable postgresql
sudo dnf install -y postgresql16-server
sudo /usr/pgsql-16/bin/postgresql-16-setup initdb
sudo systemctl enable postgresql-16
sudo systemctl start postgresql-16
```

### ✅ 사용자 및 DB 생성
```sql
CREATE ROLE [사용자] WITH LOGIN PASSWORD '[비밀번호]';
ALTER ROLE [사용자] CREATEDB;
CREATE DATABASE cms_shin OWNER [사용자];
CREATE DATABASE cms_cmtech OWNER [사용자];
```

### ✅ 외부 접속 허용 설정
- `pg_hba.conf`, `postgresql.conf` 수정 후 서비스 재시작

---

## 4. WAS 구성 (Tomcat + JDK)

### ✅ JDK 설치
```bash
dnf install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
```

### ✅ Tomcat 다운로드 및 인스턴스 분리 실행
```bash
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.104/bin/apache-tomcat-9.0.104.tar.gz
```
- 8080 포트: `/usr/local/was/tomcat_shin`
- 8180 포트: `/usr/local/was/tomcat_cmtech`

---

## 5. 프로젝트 템플릿 Clone & Push

```bash
git clone https://github.com/D0iloppa/spring5-template-jdk8.git [프로젝트명]
cd [프로젝트명]
git remote remove origin
git remote add origin https://github.com/USERNAME/new-repo.git
git push -u origin main
```

---

## 6. 컨텐츠 시스템 연동 예시

### 📦 API
```bash
GET /cms/bbs/getContentsList/{bbs_id}
```
- 응답에 포함된 `imageUrl`을 통해 이미지 출력 가능
- 예: `<img src="/cms/cdn/img/28">`

### 📷 이미지 썸네일 뷰 (swiper 연동)
```js
let bbs = new CmsBbsMng('#selector', bbs_id);
```

---

## 7. WYSIWYG 에디터 연동

- summernote (https://summernote.org/)
- ckeditor5 (https://ckeditor.com/ckeditor-5/)

게시판별 컨텐츠 등록 및 이미지 첨부 기능 연동됨.

---

## 8. 기타

### 📁 app.properties 예시 (공유되나 커밋 제외 필요)
```properties
# db.driver=org.postgresql.Driver
# db.url=jdbc:postgresql://[host]:5432/cms_shin
# db.username=... (공유 필요)
# db.password=... (비공개 필요)
```
※ 커밋 시 실수 방지를 위해 수동으로 ` git reset HEAD resources/config/app.properties` 처리 필요

---

## 🔗 ERD 참고
https://dbdiagram.io/d/6803499b1ca52373f58e0672

---

## 📎 관리자 접속 경로
http://localhost:8080/cms/admin?menu=bbsMng

