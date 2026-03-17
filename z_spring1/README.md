# Spring Legacy 기반 답변형 게시판 (z_spring1)
스프링 레거시 환경에서 구현한 기본 게시판 프로젝트입니다.

## 🛠 Tech Stack
- Java 1.8 / Spring Framework 4.3.4.RELEASE
- MariaDB / MyBatis 
- JSP / JSTL / Ajax
- Eclipse 2018-09

## 📂 DB Setup
DB 설정과 관련된 SQL 파일은 추후 z_spring02에 안내해 드릴 예정입니다.
(해당 프로젝트에서는 회원가입 기능이 없음)

> **주의**: `root-context.xml`의 DB 접속 정보(${YOUR_SCHEMA}, ${YOUR_DB_ID}, ${YOUR_DB_PASSWORD})를 본인 환경에 맞게 수정해야 합니다.

## 📝 주요 구현 기능
- 게시판 CRUD (작성, 상세조회, 수정, 삭제)
- 답글(Reply) 로직 (group_no, print_no, print_level 활용)
- 조회수 증가 처리
- 로그인한 사람 본인만 수정/삭제 할 수 있도록 권한 control
- 게시판 비밀번호 확인 로직 (수정/삭제 시)