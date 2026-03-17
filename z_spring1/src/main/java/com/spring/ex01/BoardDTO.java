package com.spring.ex01;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data	// Getter, Setter, RequiredArgsConstructor, ToString, EqualsAndHashCode 한 번에 해결
@NoArgsConstructor	// Jackson 이 객체를 생설할 때 필요한 default constructor를 생성해줌.
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)	// 클래스 단위로 스네이크케이스 적용
public class BoardDTO {
	
	@JsonProperty("b_no") // JSON의 "b_no"를 이 필드에 꽂으라고 명시!
	private int bNo;
	
	private String subject;
	private String writer;
	private Timestamp registDate;
	private Timestamp modifyDate;
	private int hit;
	private String content;
	
	@JsonProperty("b_password") // JSON의 "b_password"를 이 필드에 꽂으라고 명시!
	private String bPassword;
	
	private String email;
	private int groupNo;
	private int printNo;
	private int printLevel;
	
	private String upDel;

}
