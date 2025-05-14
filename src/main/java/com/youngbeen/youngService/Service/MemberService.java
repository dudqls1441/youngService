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
}