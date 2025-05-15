package com.youngbeen.youngService.Repository;

import com.youngbeen.youngService.Entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, String> {

    Optional<Member> findByUsername(String username);

    Optional<Member> findByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

//    findby[속성명] : 특정 속성으로 데이터 조회
//    existsBy[속성명]: 특정 속성을 가진 데이터의 존재 여부 확인
//    countBy[속성명]: 특정 속성을 가진 데이터의 개수 반환
//    deleteBy: 삭제

//    복합 조건
//    findByUsernameAndEmail(String username, String email)  // AND 조건
//    findByUsernameOrEmail(String username, String email)   // OR 조건
//
//    정렬 지정:
//    javafindByUsernameOrderByCreatedDateDesc(String username)  // 정렬 추가
//
//    결과 제한:
//    javafindTop5ByOrderByCreatedDateDesc()  // 상위 5개 결과만 반환
//    findFirstByOrderByUsernameAsc()     // 첫 번째 결과만 반환

//    복잡한 쿼리가 필요한 경우
//
//    @Query 애노테이션 사용:
//    java@Query("SELECT m FROM Member m WHERE m.email LIKE %:keyword% OR m.username LIKE %:keyword%")
//    List<Member> searchByKeyword(@Param("keyword") String keyword);
//
//    @Query("UPDATE Member m SET m.role = :role WHERE m.id = :id")
//    @Modifying
//    void updateRole(@Param("id") String id, @Param("role") Role role);
//
//    네이티브 쿼리 사용:
//    java@Query(value = "SELECT * FROM member WHERE created_date > DATE_SUB(NOW(), INTERVAL 1 DAY)", nativeQuery = true)
//    List<Member> findRecentMembers();

//    JPAQueryFactory queryFactory = new JPAQueryFactory(entityManager);
//    QMember member = QMember.member;
//    QTeam team = QTeam.team;
//
//    List<Tuple> result = queryFactory
//            .select(member.name, team.name, member.age.avg())
//            .from(member)
//            .join(member.team, team)
//            .groupBy(team.name)
//            .fetch();

}