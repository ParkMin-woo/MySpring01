package com.spring.ex01;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
// 가상 URL 주소로 접속하면 호출되는 메소드를 소유한 [LoginController 컨트롤러 클래스] 선언.
// @Controller를 붙임으로서 [컨트롤러 클래스]임을 지정한다.
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
@Controller
public class LoginController {
	
	// ***********************************************************
	// 속성변수 loginService 선언하고, LoginService라는 인터페이스를 구현한 클래스를 객체화하여 저장
	// ***********************************************************
		// @Autowired이 붙은 속성변수에는 인터페이스 자료형을 쓰고,
		// 이 인터페이스를 구현한 클래스를 객체화하여 저장한다.
		// LoginService라는 인터페이스를 구현한 클래스의 이름은 몰라도 관계없다.
		// 1개 존재하기만 하면 된다.
	// ***********************************************************
	@Autowired
	private LoginService loginService;

	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

	// ***********************************************************
	// 가상주소 /ex01/loginForm.do로 접속하면 호출되는 메소드 선언.
	// ***********************************************************
	// [컨트롤러 클래스]의 메소드에 @ResponseBody가 없고, @RequestMapping 붙고
	// 메소드의 리턴형이 String일 경우 리턴하는 문자열은 호출할 JSP 페이지명이다.
	// ***********************************************************
	/*
	@RequestMapping(value = "/loginForm.do", method = RequestMethod.GET)
	public String loginForm(HttpServletRequest request, Model model) {
		// **************************************************
		// HttpSession 객체에 저장된 로그인 성공 아이디 삭제하기
		// **************************************************
		HttpSession session = request.getSession();
		session.removeAttribute("loginId");
		
		// **************************************************
		// Cookie 객체에 저장된 아이디, 암호 관련 쿠키값을 저장할 변수 선언하기.
		// **************************************************
		String loginIdCookie = null;
		String pwdCookie = null;
		// boolean checked = false;
		
		// ---------------------------------------------------------------------
		// 클라이언트가 보내온 쿠키를 관리하는 Cookie[] 메위주 얻기.
		// ---------------------------------------------------------------------
			// Cookie[] 객체는 HttpServletRequest 객체의 메소드를 호출하여 얻는다.
			// HttpServletRequest 객체는 Request라는 제공객참변수에 저장되어 제공된다.
			// --------------------------------------------------------------------------
		Cookie[] cookies = request.getCookies();
		// ---------------------------------------------------------------------
		// Cookie[] 객체에서 아이디, 암호를 꺼내어 변수에 저장하기.
		// ---------------------------------------------------------------------
		if(cookies!=null) {
			for(int i = 0; i<cookies.length;i++) {
				// i번째 배열변수에 저장된 Cookie 객체의 쿠키명이 login_id가 가지고 있는 값과 같으면
				// 쿠키값을 꺼내어 변수 login_id_cookie에 저장
				if(cookies[i].getName().equals("loginId") ) {
					loginIdCookie = cookies[i].getValue();
					// System.out.println(login_id_cookie);
				}
				// i번째 배열변수에 저장된 Cookie 객체의 쿠키명이 pwd가 가지고 있는 값과 같으면
				// 쿠키값을 꺼내어 변수 pwd_cookie에 저장
				if(cookies[i].getName().equals("pwd") ) {
					pwdCookie = cookies[i].getValue();
					// System.out.println(pwd_cookie);
				}
			}
		}
		// if( login_id_cookie.length() > 0 ) {checked=true; System.out.println(checked);}
		
		// ***********************************************
		// HttpServletRequset 객체에 데이터 저장하기.		
		// ***********************************************
		// request.setAttribute("loginIdCookie",loginIdCookie);
		// request.setAttribute("pwdCookie",pwdCookie);
		// request.setAttribute("checked",checked);
		
		// ***********************************************
		// model.addAttribute 이용하여 저장하기		
		// ***********************************************
		model.addAttribute("loginIdCookie",loginIdCookie);
		model.addAttribute("pwdCookie",pwdCookie);
		
		return "loginForm.jsp";
	}
	*/
	
	// 위 public String loginForm( ~ ) 메소드는 아래처럼 작성할 수 있다.
	// ***********************************************************
	// 가상주소 /ex01/loginForm.do로 접속하면 호출되는 메소드 선언.
	// ***********************************************************
	// 리턴하는 객체가 ModelAndView 객체일 경우
	// ModelAndView 객체에는 호출 JSP 페이지와 DB연동 결과물이 저장되어 있다.
	// 추후 JSP 페이지가 호출되면서 DB연동 결과물이 JSP 페이지에서 EL, 커스텀태그로 반영된다.
	// <ex> mav.addObject("loginIdCookie",loginIdCookie);
	//		mav.addObject("pwdCookie",pwdCookie);
	
	// 		mav.setViewName("loginForm");
	// ***********************************************************
	// <주의> 메소드 이름과 가상주소는 절대 매핑하는 거 아니다.
	@RequestMapping(value="/loginForm.do")
	// @RequestMapping("/loginForm.do")
	public ModelAndView loginForm(HttpServletRequest request, HttpSession session) {
		// System.out.println( "1" );
		// -----------------------------
		// ModelAndView 객체 생성
		// -----------------------------
		ModelAndView mav = new ModelAndView();
		
		// System.out.println( "2" );
		// -----------------------------
		// xxx라는 키값으로 문자열 "배고파"를 ModelAndView 객체에 저장
		// 이렇게 저장된 객체는 호출할 JSP 페이지 안에서 ${xxx} 형식으로 표현된다.
		// -----------------------------
		// mav.addObject("xxx" , "배고파");
		
		try {
			// HttpSession 객체에 저장된 로그인 아이디를 제거하기.
			// 있으면 지우고, 없으면 말고~~~
			session.removeAttribute("loginId");

			
			// **************************************************
			// Cookie 객체에 저장된 아이디, 암호 관련 쿠키값을 저장할 변수 선언하기.
			// **************************************************
			String loginIdCookie = null;
			String pwdCookie = null;
			
			// ---------------------------------------------------------------------
			// 클라이언트가 보내온 쿠키를 관리하는 Cookie[] 메위주 얻기.
			// ---------------------------------------------------------------------
				// Cookie[] 객체는 HttpServletRequest 객체의 메소드를 호출하여 얻는다.
				// HttpServletRequest 객체는 Request라는 제공객참변수에 저장되어 제공된다.
				// --------------------------------------------------------------------------
			Cookie[] cookies = request.getCookies();
			// ---------------------------------------------------------------------
			// Cookie[] 객체에서 아이디, 암호를 꺼내어 변수에 저장하기.
			// ---------------------------------------------------------------------
			if(cookies!=null) {
				for(int i = 0; i<cookies.length;i++) {
					// i번째 배열변수에 저장된 Cookie 객체의 쿠키명이 login_id가 가지고 있는 값과 같으면
					// 쿠키값을 꺼내어 변수 login_id_cookie에 저장
					if(cookies[i].getName().equals("loginId") ) {
						loginIdCookie = cookies[i].getValue();
						// System.out.println(login_id_cookie);
					}
					// i번째 배열변수에 저장된 Cookie 객체의 쿠키명이 pwd가 가지고 있는 값과 같으면
					// 쿠키값을 꺼내어 변수 pwd_cookie에 저장
					if(cookies[i].getName().equals("pwd") ) {
						pwdCookie = cookies[i].getValue();
						// System.out.println(pwd_cookie);
					}
				}
			}
			
			// ***********************************************
			// HttpServletRequset 객체에 데이터 저장하기.		
			// ***********************************************
			// request.setAttribute("loginIdCookie",loginIdCookie);
			// request.setAttribute("pwdCookie",pwdCookie);
			// request.setAttribute("checked",checked);
			
			// ***********************************************
			// mav.addObject 이용하여 저장하기		
			// ***********************************************
			mav.addObject("loginIdCookie",loginIdCookie);
			mav.addObject("pwdCookie",pwdCookie);
			
			// -----------------------------
			// 호출할 JSP 페이지명을 ModelAndView 객체에 저장
			// -----------------------------
			mav.setViewName("loginForm");
		} catch(Exception ex) {
			System.out.println("LoginController.loginForm(~)에서 에러 발생");
		}
		// ModelAndView 객체 리턴
		return mav;
	}
	
	// 가상주소 /erp/loginProc.do로 접속하면 호출되는 메소드 선언.
	@RequestMapping(value="/loginProc.do", method=RequestMethod.POST)
	public ModelAndView loginProc(
		// HttpSession 객체가 저장되는 매개변수 선언.
		HttpSession session
		// HttpServletResponse 객체가 저장되는 매개변수 선언.
		, HttpServletResponse response
		// -----------------------------
		// @RequestParam("파라미터명") 자료형 변수명
		// -----------------------------
		// 파라미터명에 해당하는 파라미터값을 매개변수에 저장해주세요.
		// , @RequestParam("login_id") String login_id
		// , @RequestParam("password") String password
		, @RequestBody LoginDTO loginDTO
	) {
		// -----------------------------
		// ModelAndView 객체 생성
		// -----------------------------
		ModelAndView mav = new ModelAndView();
		
		/*
		logger.info("loginId {}.", loginDTO.getLoginId());
		logger.info("pwd {}.", loginDTO.getPwd());
		logger.info("isLogin {}.", loginDTO.getIsLogin());
		
		logger.info("loginDTO {}.", loginDTO);
		*/
		
		// ----------------------------
		// LoginServiceImpl 객체의 getLoginCnt() 메소드 호출로
		// [로그인 아이디 존재 개수]를 얻기
		// ----------------------------
		int loginIdCnt = this.loginService.getLoginIdCnt(loginDTO);
		// logger.info("loginIdCnt {}.", loginIdCnt);
		
		// ----------------------------
		// 로그인이 성공하면 HttpSession 객체에 로그인 아이디를 저장.
		// 그리고 로그인 아이디의 존재 개수를 ModelAndView 객체에 저장하기
		// ----------------------------
		if( loginIdCnt == 1 ) {
			// -----------------------------
			// HttpSession 객체에 로그인 아이디를 저장
			// -----------------------------
			session.setAttribute("loginId" , loginDTO.getLoginId());
			
			String isLogin = loginDTO.getIsLogin();
			// ----------------------------------------------------
			// [아이디, 암호 저장 의사]가 없을 경우 [아이디, 암호 관련 쿠키]를 null로 덮어 씌우고 수명 없애기.
			// ----------------------------------------------------
			if(isLogin.equals("N")) {
				Cookie cookie1 = new Cookie("loginId", null);
				cookie1.setMaxAge(0);
				response.addCookie(cookie1);
				
				Cookie cookie2 = new Cookie("pwd", null);
				cookie2.setMaxAge(0);
				response.addCookie(cookie2);
			}
			// ----------------------------------------------------
			// [아이디, 암호 저장 의사]가 있을 경우 [아이디, 암호 관련 쿠키]를 만들고 수명 정하기.
			// 그리고 이 쿠키를 HttpServletResponse 객체에 저장하기.
			// ----------------------------------------------------
			else {
				Cookie cookie1 = new Cookie("loginId", loginDTO.getLoginId());
				cookie1.setMaxAge(60*60*24);
				response.addCookie(cookie1);
				
				Cookie cookie2 = new Cookie("pwd", loginDTO.getPwd());
				cookie2.setMaxAge(60*60*24);
				response.addCookie(cookie2);
			}
		}
		// -----------------------------
		// 로그인 아이디 존재 개수를 ModelAndView 객체에 저장하기
		// -----------------------------
		mav.addObject("loginIdCnt" , loginIdCnt);
		
		// -----------------------------
		// 호출할 JSP 페이지명을 ModelAndView 객체에 저장
		// -----------------------------
		mav.setViewName("loginProc");
		
		return mav;
	}
	
}
