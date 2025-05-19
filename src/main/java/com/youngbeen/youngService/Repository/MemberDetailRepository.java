package com.youngbeen.youngService.Repository;

import com.youngbeen.youngService.Entity.MemberDetail;
import org.apache.ibatis.annotations.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MemberDetailRepository extends JpaRepository<MemberDetail, String> {

    @Query("SELECT md FROM MemberDetail md WHERE md.member.id = :memberId")
    Optional<MemberDetail> findByMemberId(@Param("memberId") String memberId);
}
