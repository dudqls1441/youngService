<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    </div>
</div>

<!-- Bootstrap core JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 공통 스크립트 -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 토글 기능 설정
        document.body.addEventListener('click', function(e) {
            if (e.target.id === 'sidebarToggle' || e.target.closest('#sidebarToggle')) {
                e.preventDefault();
                document.getElementById('wrapper').classList.toggle('toggled');
                document.getElementById('sidebar-wrapper').classList.toggle('toggled');
                document.getElementById('content-wrapper').classList.toggle('toggled');
            }
        });
    });
</script>
</body>
</html>