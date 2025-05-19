package com.youngbeen.youngService.Service;

import com.youngbeen.youngService.Entity.Certificate;
import com.youngbeen.youngService.Repository.CertificateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CertificateService {

    @Autowired
    private CertificateRepository certificateRepository;

    /**
     * 회원 상세 ID로 자격증 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Certificate> findByMemberDetailId(Long memberDetailId) {
        return certificateRepository.findByMemberDetailId(memberDetailId);
    }
}