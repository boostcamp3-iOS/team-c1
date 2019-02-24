## Project CoCo

&nbsp;
강아지와 고양이를 키우는 사람들을 위한 쇼핑 앱으로 반려동물용품을 쉽고 편리하게 구매할 수 있는 서비스입니다.

&nbsp;
## Boostcamp3 Team C1
* [강준영](https://github.com/lavaKangJun)
* [이호찬](https://github.com/LHOCHAN)
* [최영준](https://github.com/0jun0815)

&nbsp;
## 개발 관련 사항
* `Swift4.2`, `Xcode 10.1`에서 개발되었습니다.
* [코드 규칙](https://github.com/boostcamp3-iOS/team-c1/wiki/코드-규칙)을 따릅니다.
* Boostcamp3 [핵심 요구사항](https://github.com/boostcamp3-iOS/team-c1/wiki/핵심-기술요구사항)을 준수합니다.
* [네이버 검색 - 쇼핑 API](https://developers.naver.com/docs/search/shopping)를 사용합니다.


&nbsp;
## 사용된 기술
* Animation
* CoreData
* HTTP/HTTPS Networking
* Image Caching
* Pinterest Layout

### 기술 관련 사항
* [이미지 캐시 - Kingfisher 분석](https://github.com/0jun0815/Kingfisher-Analysis)
* [의존성 주입(Dependency Injection, DI)](https://github.com/boostcamp3-iOS/team-c1/wiki/의존성-주입(Dependency-Injection,-DI))
* [상품 추천](https://github.com/boostcamp3-iOS/team-c1/wiki/상품-추천)

### 앱 구조
![appstruct](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/appstruct.png)

&nbsp;
## 화면
> [시연 영상](https://www.youtube.com/watch?v=ltucBH8zWoo&feature=youtu.be)
&nbsp;

### 펫, 키워드 선택 뷰
* 앱 첫 실행시 반려동물과 관심 키워드를 선택할 수 있습니다.

![launchscreen](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/launchscreen.png)
![petkeyword](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/petkeyword.png)

### 둘러보기 뷰
* 사용자 맞춤 추천 상품을 보여주며, 위의 카테고리를 누르면 해당 카테고리의 상세 카테고리로 넘어갑니다.
* 상세 카테고리별 상품도 확인할 수 있으며 정렬 기능을 제공합니다.

![discovery](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/discovery.png)
![category](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/category.png)

### 검색 뷰
* 추천 검색어를 통해 상품을 쉽게 검색할 수 있으며, 직접 검색도 가능합니다.
* 상품을 선택하면 웹 뷰로 연결됩니다.

![search](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/search.png)
![search2](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/search2.png)

### 웹 뷰, 내 상품 뷰
* 마음에 드는 상품을 찜할 수 있으며 내 상품에서 최근 본 상품과 찜한 상품을 확인 및 편집할 수 있습니다.

![webview](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/webview.png)
![mygoods](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/mygoods.png)

### 설정 뷰
* 반려동물과 관심 키워드를 변경할 수 있으며 캐시 데이터를 지울 수 있습니다.

![setting](https://github.com/boostcamp3-iOS/team-c1/blob/develop/Images/setting.png)

