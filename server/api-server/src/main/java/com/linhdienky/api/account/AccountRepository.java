package com.linhdienky.api.account;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * Repository: đọc/ghi bảng account.
 *
 * JpaRepository<Account, Long> đã có sẵn: save(), findById(), findAll(), deleteById()...
 * Chỉ cần khai báo thêm method theo QUY TẮC ĐẶT TÊN, Spring tự sinh câu SQL:
 *   findBy...      -> SELECT ... WHERE ...         (trả về Optional / List)
 *   existsBy...    -> SELECT EXISTS(... WHERE ...) (trả về boolean)
 *   ...IgnoreCase  -> so sánh không phân biệt hoa thường
 */
public interface AccountRepository extends JpaRepository<Account, Long> {
    //                                                ↑ Entity  ↑ kiểu của id

    // Tìm tài khoản theo username (dùng khi đăng nhập)
    // SQL tương đương: SELECT * FROM account WHERE LOWER(username) = LOWER(?)
    Optional<Account> findByUsernameIgnoreCase(String username);

    // TODO: existsByUsernameIgnoreCase -> kiểm tra username đã tồn tại chưa (dùng khi đăng ký)
    boolean existsByUsernameIgnoreCase(String username);
    // TODO: existsByEmailIgnoreCase -> kiểm tra email đã tồn tại chưa (dùng khi đăng ký)
    boolean existsByEmailIgnoreCase(String email);
}
