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
import org.springframework.web.bind.annotation.*;

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
     * 비밀번호 찾기 폼
     */
    @GetMapping("/password")
    public String passwordForm(Model model) {
        return "findPasswordForm";
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
        logger.debug("YBYB logout start");
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
     * 인증번호 발송
     */
    @PostMapping("/password/sendCode")
    public String sendVerificationCode(@RequestParam String email, HttpSession session, Model model) {
        try {
            // 이메일 존재 여부 확인
            if (!memberService.existsByEmail(email)) {
                model.addAttribute("errorMessage", "해당 이메일로 등록된 계정이 없습니다.");
                return "findPasswordForm";
            }

            // 인증번호 생성 및 발송
            String verificationCode = memberService.generateAndSendVerificationCode(email);

            // 세션에 이메일과 인증번호 저장
            session.setAttribute("resetEmail", email);
            session.setAttribute("verificationCode", verificationCode);
            session.setAttribute("codeExpireTime", System.currentTimeMillis() + (10 * 60 * 500)); // 5분 유효시간

            model.addAttribute("email", email);
            model.addAttribute("successMessage", "인증번호가 이메일로 발송되었습니다. 5분 이내에 입력해주세요.");

            return "resetPasswordForm";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "인증번호 발송 중 오류가 발생했습니다: " + e.getMessage());
            return "findPasswordForm";
        }
    }

    /**
     * 비밀번호 재설정
     */
    @PostMapping("/resetPassword")
    public String resetPassword(
            @RequestParam String email,
            @RequestParam String verificationCode,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session,
            Model model) {

        // 세션에서 인증 정보 가져오기
        String storedEmail = (String) session.getAttribute("resetEmail");
        String storedCode = (String) session.getAttribute("verificationCode");
        Long expireTime = (Long) session.getAttribute("codeExpireTime");

        // 인증 정보 확인
        if (storedEmail == null || storedCode == null || expireTime == null) {
            model.addAttribute("errorMessage", "인증 세션이 만료되었습니다. 다시 시도해주세요.");
            return "findPasswordForm";
        }

        // 이메일 일치 확인
        if (!email.equals(storedEmail)) {
            model.addAttribute("errorMessage", "이메일 정보가 일치하지 않습니다.");
            model.addAttribute("email", storedEmail);
            return "resetPasswordForm";
        }

        // 인증번호 만료 확인
        if (System.currentTimeMillis() > expireTime) {
            // 세션 정보 삭제
            session.removeAttribute("resetEmail");
            session.removeAttribute("verificationCode");
            session.removeAttribute("codeExpireTime");

            model.addAttribute("errorMessage", "인증번호가 만료되었습니다. 다시 시도해주세요.");
            return "findPasswordForm";
        }

        // 인증번호 일치 확인
        if (!verificationCode.equals(storedCode)) {
            model.addAttribute("errorMessage", "인증번호가 일치하지 않습니다.");
            model.addAttribute("email", storedEmail);
            return "resetPasswordForm";
        }

        // 비밀번호 일치 확인
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            model.addAttribute("email", storedEmail);
            return "resetPasswordForm";
        }

        try {
            // 비밀번호 재설정
            memberService.resetPassword(email, newPassword);

            // 세션 정보 삭제
            session.removeAttribute("resetEmail");
            session.removeAttribute("verificationCode");
            session.removeAttribute("codeExpireTime");

            model.addAttribute("successMessage", "비밀번호가 성공적으로 재설정되었습니다. 새 비밀번호로 로그인해주세요.");
            return "loginForm";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "비밀번호 재설정 중 오류가 발생했습니다: " + e.getMessage());
            model.addAttribute("email", storedEmail);
            return "resetPasswordForm";
        }
    }
}
