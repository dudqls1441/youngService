package com.youngbeen.youngService.Service;

import com.youngbeen.youngService.DTO.MemberDTO;
import com.youngbeen.youngService.Entity.Member;

import java.util.Optional;

import java.util.Optional;

public interface MemberService {

    /**
     * 회원가입
     */
    String join(MemberDTO memberDto);

    /**
     * 로그인
     */
    Member login(String username, String password);

    /**
     * 회원 정보 조회
     */
    Member findById(String id);

    /**
     * 아이디로 회원 조회
     */
    Optional<Member> findByUsername(String username);

    /**
     * 이메일 존재 여부 확인
     */
    boolean existsByEmail(String email);

    /**
     * 인증번호 생성 및 이메일 발송
     * @return 생성된 인증번호
     */
    String generateAndSendVerificationCode(String email);

    /**
     * 비밀번호 재설정
     */
    void resetPassword(String email, String newPassword);
}