package com.linhdienky.api.account;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;

/**
 * Entity ánh xạ bảng "account".
 *
 * Quy tắc:
 *  - Mỗi field = 1 cột. Tên field viết camelCase, Spring tự đổi sang snake_case
 *    (passwordHash -> password_hash, createdAt -> created_at).
 *  - ddl-auto: validate -> nếu field lệch với bảng (thiếu cột, sai kiểu) server sẽ không chạy.
 */
@Entity                      // Đánh dấu: class này là 1 bảng trong DB
@Table(name = "account")     // Tên bảng
@Getter                      // Lombok: tự sinh getXxx()
@Setter                      // Lombok: tự sinh setXxx()
@NoArgsConstructor           // JPA bắt buộc có constructor không tham số
public class Account {

    // ===== Khóa chính =====
    @Id                                                    // Đây là khóa chính
    @GeneratedValue(strategy = GenerationType.IDENTITY)    // DB tự tăng (BIGSERIAL)
    private Long id;

    // ===== Thông tin đăng nhập =====
    @Column(nullable = false, length = 20)   // NOT NULL, VARCHAR(20)
    private String username;

    @Column(nullable = false, length = 255)
    private String email;

    @Column(nullable = false, length = 60)
    private String passwordHash;

    // ===== Phân quyền & trạng thái =====
    @Enumerated(EnumType.STRING)              // Lưu chữ "USER"/"ADMIN" thay vì số 0/1
    @Column(nullable = false, length = 10)
    private Role role = Role.USER;            // Mặc định là người chơi thường

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private AccountStatus status = AccountStatus.ACTIVE;
    
    // ===== Thời gian =====
    private Instant lastLoginAt;              // Lần đăng nhập cuối, được phép null

    @CreationTimestamp                        // Hibernate tự gán lúc INSERT
    @Column(nullable = false, updatable = false)  // Không bao giờ bị sửa sau khi tạo
    private Instant createdAt;

    @UpdateTimestamp                           // Hibernate tự gán lúc UPDATE
    @Column(nullable = false)                 // Không bao giờ được null
    private Instant updatedAt;
}
