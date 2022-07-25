# iOS 개발 규칙

## Arcitecture, DesignPattern and Library

- 본 프로젝트는 `MVVM` 아키텍처로 구성되어있습니다.
- `RxSwift`, `SnapKit` 라이브러리를 사용합니다.

## Code Writing Rules

- 변수의 네이밍은 명확하게 적어주세요!
- 본인이 작성한 클래스, 함수 위에 주석(doc)을 달아주세요!
  - 함수의 경우 매개변수, 리턴등 추가 사항이 들어가면 더욱 좋습니다!
- 네이밍은 `camelCase`로 작성해주세요!

## Commit Message Rules
- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 수정
- `test`: 테스트 코드 추가
- `refactor`: 코드 리팩토링
- `style`: 코드 의미에 영향을 주지 않는 변경사항
- `chore`: 빌드 부분 혹은 패키지 매니저 수정사항
- `init`: 프로젝트 초기 셋팅

## Git branch (Git-flow)
- `master` : 기준이 되는 브랜치로 제품을 배포하는 브랜치
- `develop` : 개발 브랜치로 개발자들이 이 브랜치를 기준으로 각자 작업한 기능들을 Merge
- `feature` : 단위 기능을 개발하는 브랜치로 기능 개발이 완료되면 develop 브랜치에 Merge
- `release` : 배포를 위해 master 브랜치로 보내기 전에 먼저 QA(품질검사)를 하기위한 브랜치

1. master 브랜치에서 develop 브랜치를 분기합니다.
2. 개발자들은 develop 브랜치에 자유롭게 커밋을 합니다.
3. 기능 구현이 있는 경우 develop 브랜치에서 feature-* 브랜치를 분기합니다.
4. 배포를 준비하기 위해 develop 브랜치에서 release-* 브랜치를 분기합니다.
5. 테스트를 진행하면서 발생하는 버그 수정은 release-* 브랜치에 직접 반영합니다.
6. 테스트가 완료되면 release 브랜치를 master와 develop에 merge합니다.

## Git Convention
1. commit
  - 커밋은 하나의 기능만 커밋합니다. 기능이 여러개일 경우 나눠서 커밋해주세요!
  - 커밋 메세지는 아래 양식을 사용합니다. 이슈 사항을 개발한 경우 맨 앞에 이슈번호를 기재해 주세요!
```markdown
[#1]Feat: 소셜 로그인 추가
- 구글 로그인 기능을 추가했습니다.
```

2. issue
  - 이슈 유형 파악을 위해 태그를 사용해주세요!
  - 이슈를 해결하면 해당 이슈를 종료해주세요!
