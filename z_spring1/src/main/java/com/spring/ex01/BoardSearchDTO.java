package com.spring.ex01;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data	// Getter, Setter, RequiredArgsConstructor, ToString, EqualsAndHashCode 한 번에 해결
@NoArgsConstructor	// Jackson 이 객체를 생설할 때 필요한 default constructor를 생성해줌.
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)	// 클래스 단위로 스네이크케이스 적용
public class BoardSearchDTO {

	// ************************************
	// 속성변수 선언
	// ************************************
	private String keyword;				// 검색 키워드 저장
	private String keywordContent;		// 검색 키워드가 검색할 대상 저장
	// --------------------------------------------
	private int rowCntPerPage = 15;		// 한 화면에 보여지는 검색 결과 최대행 개수 저장. <주의> 반드시 초기값 입력할 것.
	private int selectPageNo = 1;		// 현재 선택된 페이지 번호 저장. <주의> 반드시 초기값 입력할 것.
	private int startRowNo;				// 게시판 검색 시 [선택한 페이지번호]에 해당하는 시작행 번호 저장.

}
