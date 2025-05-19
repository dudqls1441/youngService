package com.youngbeen.youngService.Repository;

import com.youngbeen.youngService.Entity.Certificate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CertificateRepository extends JpaRepository<Certificate, Long> {

    List<Certificate> findByMemberDetailId(Long memberDetailId);

    void deleteAllByMemberDetailId(Long memberDetailId);
}
