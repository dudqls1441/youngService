package com.youngbeen.youngService.Service.impl;

import com.youngbeen.youngService.DTO.CertificateDTO;
import com.youngbeen.youngService.DTO.MemberDTO;
import com.youngbeen.youngService.DTO.MemberDetailDTO;
import com.youngbeen.youngService.Entity.Certificate;
import com.youngbeen.youngService.Entity.Member;
import com.youngbeen.youngService.Entity.MemberDetail;
import com.youngbeen.youngService.Repository.CertificateRepository;
import com.youngbeen.youngService.Repository.MemberDetailRepository;
import com.youngbeen.youngService.Repository.MemberRepository;
import com.youngbeen.youngService.Service.MemberService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Value;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MemberServiceImpl implements MemberService {
    private static final Logger logger = LoggerFactory.getLogger(MemberServiceImpl.class);

    private final CommonServiceImpl commonServiceImpl;

    @Autowired
    private final MemberRepository memberRepository;

    @Autowired
    private final MemberDetailRepository memberDetailRepository;

    @Autowired
    private final CertificateRepository certificateRepository;

    @Autowired
    private final PasswordEncoder passwordEncoder;

    @Autowired
    private JavaMailSender mailSender; // 이메일 발송 서비스 (application.properties에 설정 필요)

    /**
     * 회원가입
     */
    @Override
    @Transactional
    public String join(MemberDTO memberDto) {
        // 아이디 중복 검사
        if (memberRepository.existsByUsername(memberDto.getId())) {
            throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
        }

        // 이메일 중복 검사
        if (memberRepository.existsByEmail(memberDto.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // 비밀번호 암호화
        Member member = Member.builder()
                .id(memberDto.getId())
                .password(passwordEncoder.encode(memberDto.getPassword()))
                .username(memberDto.getUsername())
                .email(memberDto.getEmail())
                .role(Member.Role.USER)
                .build();

        logger.debug("member::{}",member.toString());

        memberRepository.save(member);
        return member.getId();
    }

    /**
     * 로그인
     */
    @Override
    public Member login(String username, String password) {
        logger.debug("username :: {}, password :: {}" , username, password);

        Member member = memberRepository.findById(username)
                .orElseThrow(() -> new IllegalArgumentException("아이디 또는 비밀번호가 일치하지 않습니다."));

        // 비밀번호가 BCrypt 형식인지 확인
        boolean isPasswordMatched;
        if (member.getPassword().startsWith("$2a$")) {
            // BCrypt로 암호화된 비밀번호면 matches 사용
            isPasswordMatched = passwordEncoder.matches(password, member.getPassword());
        } else {
            // 평문 비밀번호면 직접 비교
            isPasswordMatched = password.equals(member.getPassword());

            // 선택적: 이 기회에 비밀번호 암호화하기
            if (isPasswordMatched) {
                member.setPassword(passwordEncoder.encode(password));
                memberRepository.save(member);
                logger.info("사용자 {}의 비밀번호를 암호화했습니다.", username);
            }
        }

        if (!isPasswordMatched) {
            throw new IllegalArgumentException("아이디 또는 비밀번호가 일치하지 않습니다.");
        }

        return member;
    }

    /**
     * 회원 정보 조회
     */
    @Override
    public Member findById(String id) {
        return memberRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
    }

    /**
     * 아이디로 회원 조회
     */
    @Override
    public Optional<Member> findByUsername(String username) {
        return memberRepository.findByUsername(username);
    }


    @Override
    public boolean existsByEmail(String email) {
        return memberRepository.existsByEmail(email);
    }

    @Override
    public String generateAndSendVerificationCode(String email) {
        // 6자리 랜덤 숫자 생성
        String verificationCode = generateVerificationCode();
        logger.debug("인증번호 생성: {}", verificationCode);

        // 이메일 발송
        SimpleMailMessage mailMessage = new SimpleMailMessage();
        mailMessage.setTo(email);
        mailMessage.setSubject("[YOUNG 대시보드] 비밀번호 재설정 인증번호");
        mailMessage.setText("안녕하세요. YOUNG 대시보드입니다.\n\n" +
                "비밀번호 재설정을 위한 인증번호는 " + verificationCode + " 입니다.\n" +
                "인증번호는 5분간 유효합니다.\n\n" +
                "본인이 요청하지 않은 경우 이 메일을 무시하셔도 됩니다.");

        try {
            mailSender.send(mailMessage);
            logger.debug("인증메일 발송 성공: {}", email);
            return verificationCode;
        } catch (Exception e) {
            logger.error("인증메일 발송 실패: {}", e.getMessage());
            throw new RuntimeException("인증메일 발송에 실패했습니다.", e);
        }
    }

    @Override
    @Transactional
    public void resetPassword(String email, String newPassword) {
        Member member = memberRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("해당 이메일로 등록된 계정이 없습니다."));

        // 비밀번호 암호화 및 업데이트
        member.setPassword(passwordEncoder.encode(newPassword));
        memberRepository.save(member);

        logger.debug("비밀번호 재설정 완료: {}", email);
    }

    @Transactional(readOnly = true)
    public boolean isEmailVerified(String memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다: " + memberId));

        return Integer.valueOf(1).equals(member.getEmailVerified());
    }


    /**
     * 회원 상세 정보 조회
     */
    @Transactional(readOnly = true)
    public MemberDetail getMemberDetailByMemberId(String memberId) {
        Optional<MemberDetail> optionalMemberDetail = memberDetailRepository.findByMemberId(memberId);
        return optionalMemberDetail.orElse(null);
    }

    /**
     * 회원 상세 정보 업데이트
     */
    @Transactional
    public void updateMemberDetail(String memberId, MemberDetailDTO dto, MultipartFile profileImage) {
        // 회원 기본 정보 조회
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));

        // 회원 상세 정보 조회 또는 생성
        MemberDetail memberDetail = memberDetailRepository.findByMemberId(memberId)
                .orElse(new MemberDetail());

        // 회원 연결
        if (memberDetail.getMember() == null) {
            memberDetail.setMember(member);
        }

        logger.debug("ybyb updateMemberDetail dto :::{}",dto);

        // DTO에서 엔티티로 데이터 복사
        memberDetail.setBirthDate(dto.getBirthDate());
        memberDetail.setPhoneNumber(dto.getPhoneNumber());
        memberDetail.setGender(dto.getGender());
        memberDetail.setPostcode(dto.getPostcode());
        memberDetail.setAddress1(dto.getAddress1());
        memberDetail.setAddress2(dto.getAddress2());
        memberDetail.setHighSchool(dto.getHighSchool());
        memberDetail.setHighSchoolGraduationYear(dto.getHighSchoolGraduationYear());
        memberDetail.setUniversity(dto.getUniversity());
        memberDetail.setUniversityStatus(dto.getUniversityStatus());
        memberDetail.setMajor(dto.getMajor());
        memberDetail.setGpa(dto.getGpa());
        memberDetail.setUniversityEntranceYear(dto.getUniversityEntranceYear());
        memberDetail.setUniversityGraduationYear(dto.getUniversityGraduationYear());

        // 프로필 이미지 처리
        if (profileImage != null && !profileImage.isEmpty()) {
            String imageUrl = commonServiceImpl.uploadProfileImage(profileImage, memberId);
            memberDetail.setProfileImage(imageUrl);
        }

        // 저장
        memberDetailRepository.save(memberDetail);

        // 자격증 정보 업데이트
        updateCertificates(memberDetail, dto.getCertificates());
    }

    /**
     * 자격증 정보 업데이트
     */
    private void updateCertificates(MemberDetail memberDetail, List<CertificateDTO> certificateDtos) {
        // 기존 자격증 삭제
        certificateRepository.deleteAllByMemberDetailId(memberDetail.getId());

        // 새 자격증 추가
        if (certificateDtos != null && !certificateDtos.isEmpty()) {
            List<Certificate> certificates = new ArrayList<>();

            for (CertificateDTO dto : certificateDtos) {
                Certificate certificate = new Certificate();
                certificate.setMemberDetail(memberDetail);
                certificate.setName(dto.getName());
                certificate.setIssuer(dto.getIssuer());
                certificate.setAcquisitionDate(dto.getAcquisitionDate());
                certificate.setExpirationDate(dto.getExpirationDate());
                certificates.add(certificate);
            }

            certificateRepository.saveAll(certificates);
        }
    }


    @Transactional
    public void verifyEmail(String memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다: " + memberId));

        member.setEmailVerified(1);
        memberRepository.save(member);
    }


    /**
     * 인증 코드 생성
     */
    private String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000); // 6자리 숫자
        return String.valueOf(code);
    }

}
