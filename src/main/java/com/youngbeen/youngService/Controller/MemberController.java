package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.CertificateDTO;
import com.youngbeen.youngService.DTO.MemberDTO;
import com.youngbeen.youngService.DTO.MemberDetailDTO;
import com.youngbeen.youngService.Entity.Certificate;
import com.youngbeen.youngService.Entity.Member;
import com.youngbeen.youngService.Entity.MemberDetail;
import com.youngbeen.youngService.Repository.MemberDetailRepository;
import com.youngbeen.youngService.Repository.MemberRepository;
import com.youngbeen.youngService.Service.CertificateService;
import com.youngbeen.youngService.Service.CommonService;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.security.Principal;
import java.time.LocalDate;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
@RequiredArgsConstructor
@RequestMapping("/member")
@Slf4j
public class MemberController {
    private final MemberService memberService;

    private final CommonService commonService;

    private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

    @Autowired
    private final MemberRepository memberRepository;

    @Autowired
    private CertificateService certificateService;

    @Autowired
    private MemberDetailRepository memberDetailRepository;

    /**
     * 회원가입 폼
     */
    @GetMapping("/register")
    public String registerForm(Model model) {
        model.addAttribute("memberDto", new MemberDTO());
        return "registerForm";
    }

    /**
     * 회원관리
     */
    @GetMapping("/profile")
    public String profileForm(Model model,HttpSession session) {
        String memberId = (String) session.getAttribute("loginId");

        if (memberId == null) {
            return "redirect:/member/login";
        }
        // 기본 회원 정보 조회
        Optional<Member> optionalMember  = memberRepository.getMemberById(memberId);

        if (optionalMember.isEmpty()) {
            return "redirect:/member/login";
        }

        Member member = optionalMember.get();
        logger.debug("member:::{}",member);

        // 회원 상세 정보 조회
        Optional<MemberDetail> optionalMemberDetail = memberDetailRepository.findByMemberId(memberId);

        // 회원 상세 정보가 없는 경우 생성
        MemberDetail memberDetail;
        if(optionalMemberDetail.isEmpty()){
            memberDetail = new MemberDetail();
            memberDetail.setMember(member);
        }else{
            memberDetail = optionalMemberDetail.get();
        }

        // 자격증 정보 조회
        List<Certificate> certificates = certificateService.findByMemberDetailId(memberDetail.getId());


        // 모델에 데이터 추가
        model.addAttribute("member", member);
        model.addAttribute("memberDetail", memberDetail);
        model.addAttribute("certificates", certificates);

        return "profile";
    }

    /**
     * 프로필 정보 업데이트 처리
     */
    @PostMapping("/update-profile")
    @ResponseBody
    public ResponseEntity<?> updateProfile(
            @ModelAttribute MemberDetailDTO memberDetailDto,
            @RequestParam(required = false) MultipartFile profileImage,
            HttpServletRequest request,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        logger.debug("ybyb updateProfile");
        logger.debug("ybyb updateProfile memberDetailDto ::{}",memberDetailDto);

        try {
            // 세션에서 로그인 ID 가져오기
            String memberId = (String) session.getAttribute("loginId");

            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 자격증 정보 수동으로 처리
            List<CertificateDTO> certificates = new ArrayList<>();

            // 요청 파라미터 맵 전체 로깅
            Map<String, String[]> paramMap = request.getParameterMap();
            for (String key : paramMap.keySet()) {
                logger.debug("Param: {} = {}", key, Arrays.toString(paramMap.get(key)));
            }

            // 인덱스 패턴을 찾기 위한 정규식
            Pattern pattern = Pattern.compile("certificates\\[(\\d+)\\]\\.name");
            Set<Integer> indexes = new HashSet<>();

            // 모든 자격증 인덱스 찾기
            for (String key : paramMap.keySet()) {
                Matcher matcher = pattern.matcher(key);
                if (matcher.matches()) {
                    indexes.add(Integer.parseInt(matcher.group(1)));
                }
            }

            // 각 인덱스에 대해 자격증 DTO 생성
            for (Integer idx : indexes) {
                CertificateDTO cert = new CertificateDTO();

                String nameKey = "certificates[" + idx + "].name";
                String issuerKey = "certificates[" + idx + "].issuer";
                String acqDateKey = "certificates[" + idx + "].acquisitionDate";
                String expDateKey = "certificates[" + idx + "].expirationDate";

                if (paramMap.containsKey(nameKey) && paramMap.get(nameKey).length > 0) {
                    cert.setName(paramMap.get(nameKey)[0]);
                }

                if (paramMap.containsKey(issuerKey) && paramMap.get(issuerKey).length > 0) {
                    cert.setIssuer(paramMap.get(issuerKey)[0]);
                }

                if (paramMap.containsKey(acqDateKey) && paramMap.get(acqDateKey).length > 0) {
                    try {
                        cert.setAcquisitionDate(LocalDate.parse(paramMap.get(acqDateKey)[0]));
                    } catch (Exception e) {
                        logger.warn("날짜 파싱 오류: {}", e.getMessage());
                    }
                }

                if (paramMap.containsKey(expDateKey) && paramMap.get(expDateKey).length > 0) {
                    try {
                        cert.setExpirationDate(LocalDate.parse(paramMap.get(expDateKey)[0]));
                    } catch (Exception e) {
                        logger.warn("날짜 파싱 오류: {}", e.getMessage());
                    }
                }

                certificates.add(cert);
            }

            // 수동으로 생성한 자격증 리스트를 DTO에 설정
            memberDetailDto.setCertificates(certificates);

            // 프로필 업데이트 처리
            memberService.updateMemberDetail(memberId, memberDetailDto, profileImage);

            response.put("success", true);
            response.put("message", "프로필이 성공적으로 업데이트되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("프로필 업데이트 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "프로필 업데이트 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 대학교 검색 API
     */
    @GetMapping("/api/university/search")
    @ResponseBody
    public ResponseEntity<?> searchUniversity(@RequestParam String keyword) {
        try {
            List<Map<String, Object>> universities = commonService.searchUniversities(keyword);
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(universities);
        } catch (Exception e) {
            logger.error("대학교 검색 중 오류 발생", e);
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "대학교 검색 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
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
            session.setAttribute("userRole", loginMember.getRole());
            session.setAttribute("loginUserName", loginMember.getUsername());
            session.setAttribute("loginUserEmail", loginMember.getEmail());

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

    /**
     * 이메일 인증 코드 발송 요청 처리
     */
    @PostMapping("/send-verification-email")
    @ResponseBody
    public ResponseEntity<?> sendVerificationEmail(@RequestParam String email, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 로그인 ID 가져오기
            String memberId = (String) session.getAttribute("loginId");

            if (memberId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 이메일 형식 검증
            if (!isValidEmail(email)) {
                response.put("success", false);
                response.put("message", "유효하지 않은 이메일 형식입니다.");
                return ResponseEntity.ok(response);
            }

            // 인증코드 생성 및 이메일 발송
            String verificationCode = memberService.generateAndSendVerificationCode(email);

            // 인증코드를 세션에 저장 (5분 후 만료)
            session.setAttribute("emailVerificationCode", verificationCode);
            session.setAttribute("emailVerificationCodeTimestamp", System.currentTimeMillis());
            session.setAttribute("emailToVerify", email);

            logger.debug("이메일 인증 코드 생성 및 저장 완료: {}", email);

            response.put("success", true);
            response.put("message", "인증 코드가 이메일로 발송되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("이메일 인증 코드 발송 중 오류 발생", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 이메일 인증 코드 확인
     */
    @PostMapping("/verify-email-code")
    @ResponseBody
    public ResponseEntity<?> verifyEmailCode(@RequestParam String code, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 세션에서 정보 가져오기
            String storedCode = (String) session.getAttribute("emailVerificationCode");
            Long codeTimestamp = (Long) session.getAttribute("emailVerificationCodeTimestamp");
            String emailToVerify = (String) session.getAttribute("emailToVerify");

            if (storedCode == null || codeTimestamp == null || emailToVerify == null) {
                response.put("success", false);
                response.put("message", "인증 세션이 만료되었습니다. 다시 시도해주세요.");
                return ResponseEntity.ok(response);
            }

            // 코드 만료 확인 (5분 = 300,000 밀리초)
            long currentTime = System.currentTimeMillis();
            if (currentTime - codeTimestamp > 300000) {
                // 만료된 코드 제거
                session.removeAttribute("emailVerificationCode");
                session.removeAttribute("emailVerificationCodeTimestamp");
                session.removeAttribute("emailToVerify");

                response.put("success", false);
                response.put("message", "인증 코드가 만료되었습니다. 다시 시도해주세요.");
                return ResponseEntity.ok(response);
            }

            // 코드 일치 확인
            if (!storedCode.equals(code)) {
                response.put("success", false);
                response.put("message", "인증 코드가 일치하지 않습니다.");
                return ResponseEntity.ok(response);
            }

            // 인증 성공 처리
            String memberId = (String) session.getAttribute("loginId");
            memberService.verifyEmail(memberId);

            // 사용된 인증 코드 제거
            session.removeAttribute("emailVerificationCode");
            session.removeAttribute("emailVerificationCodeTimestamp");
            session.removeAttribute("emailToVerify");

            response.put("success", true);
            response.put("message", "이메일 인증이 완료되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("이메일 인증 확인 중 오류 발생", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 이메일 형식 검증
     */
    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email != null && email.matches(emailRegex);
    }
}
