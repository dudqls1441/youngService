package com.youngbeen.youngService.Service.impl;

import com.youngbeen.youngService.Controller.IndexController;
import com.youngbeen.youngService.DTO.MemberDTO;
import com.youngbeen.youngService.Entity.Member;
import com.youngbeen.youngService.Repository.MemberRepository;
import com.youngbeen.youngService.Service.MemberService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MemberServiceImpl implements MemberService {

    private static final Logger logger = LoggerFactory.getLogger(MemberServiceImpl.class);

    @Autowired
    private final MemberRepository memberRepository;

    @Autowired
    private final PasswordEncoder passwordEncoder;

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
                .name(memberDto.getName())
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

    public void encryptAllPasswords() {
        List<Member> members = memberRepository.findAll();
        for (Member member : members) {
            if (!member.getPassword().startsWith("$2a$")) {  // BCrypt 형식인지 확인
                member.setPassword(passwordEncoder.encode(member.getPassword()));
                memberRepository.save(member);
            }
        }
    }
}
