package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.MemberDTO;
import com.youngbeen.youngService.Entity.Member;
import com.youngbeen.youngService.Service.MemberService;
import com.youngbeen.youngService.Service.impl.StockServiceImpl;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/member")
@Slf4j
public class MemberController {
    private final MemberService memberService;

    private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

    /**
     * 회원가입 폼
     */
    @GetMapping("/register")
    public String registerForm(Model model) {
        model.addAttribute("memberDto", new MemberDTO());
        return "registerForm";
    }

    /**
     * 회원가입 처리
     */
    @PostMapping("/register")
    public String register(@Valid @ModelAttribute MemberDTO memberDto,
                           BindingResult bindingResult, Model model) {

        // 유효성 검사 실패시
        if (bindingResult.hasErrors()) {
            return "registerForm";
        }

        try {
            memberService.join(memberDto);
            return "redirect:/member/login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "registerForm";
        }
    }

    /**
     * 로그인 폼
     */
    @GetMapping("/login")
    public String loginForm() {
        logger.debug("MemberController loginForm Get");
        return "loginForm";
    }

    /**
     * 로그인 처리
     */
    @PostMapping("/login")
    public String login(String username, String password,
                        HttpSession session, Model model) {

        logger.debug("MemberController login Post 메서드 실행");

        try {
            Member loginMember = memberService.login(username, password);

            logger.debug("로그인 성공: {}", loginMember.getUsername());

            // 세션에 로그인 회원 정보 저장
            session.setAttribute("loginMember", loginMember);
            session.setAttribute("loginId", loginMember.getId());
            session.setAttribute("loginUserName", loginMember.getUsername());

            // 루트 경로로 리디렉트 (IndexController가 처리)
            return "redirect:/";

        } catch (IllegalArgumentException e) {
            logger.error("로그인 실패: {}", e.getMessage());
            model.addAttribute("errorMessage", e.getMessage());
            return "loginForm";
        }
    }

    /**
     * 로그아웃
     */
    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
// 로그아웃 전 세션 정보 로깅 (디버깅용)
        logger.debug("로그아웃: 사용자 ID={}", session.getAttribute("loginId"));

        // 세션 무효화
        session.invalidate();

        // 세션 쿠키 삭제 (더 완벽한 로그아웃을 위해)
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("JSESSIONID")) {
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                    break;
                }
            }
        }

        return "redirect:/member/login?logout=success";
    }

    /**
     * 마이페이지
     */
    @GetMapping("/mypage")
    public String myPage(HttpSession session, Model model) {
        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/member/login";
        }

        model.addAttribute("member", loginMember);
        return "myPage";
    }
}
