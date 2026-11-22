package com.linhdienky.api.auth;

import com.linhdienky.api.account.Account;
import com.linhdienky.api.account.AccountRepository;
import com.linhdienky.api.account.dto.AccountResponse;
import com.linhdienky.api.auth.dto.RegisterRequest;
import com.linhdienky.api.common.BusinessException;
import com.linhdienky.api.common.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Locale;

/**
 * Xử lý nghiệp vụ đăng ký / đăng nhập.
 *
 * Phân lớp:
 * Controller : nhận request, trả response (KHÔNG chứa logic)
 * Service : logic nghiệp vụ (kiểm tra, tính toán) <- file này
 * Repository : đọc/ghi DB
 *
 * @Service : Spring quản lý class này
 * @RequiredArgsConstructor : Lombok sinh constructor cho các field final
 *                          -> Spring tự "tiêm" AccountRepository,
 *                          PasswordEncoder vào
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;

    /**
     * Đăng ký tài khoản mới.
     *
     * @Transactional: cả method chạy trong 1 transaction.
     *                 Lỗi giữa chừng -> rollback toàn bộ, DB không bị dữ liệu dở
     *                 dang.
     */
    @Transactional
    public AccountResponse register(RegisterRequest request) {

        // Bước 1: Kiểm tra username đã tồn tại chưa
        if (accountRepository.existsByUsernameIgnoreCase(request.username())) {
            throw new BusinessException(ErrorCode.USERNAME_TAKEN);
        }

        if (accountRepository.existsByEmailIgnoreCase(request.email())) {
            throw new BusinessException(ErrorCode.EMAIL_TAKEN);
        }

        // Bước 3: Tạo Entity và gán dữ liệu
        Account account = new Account();
        account.setUsername(request.username());
        account.setEmail(request.email().toLowerCase(Locale.ROOT));
        // không lưu request.password() trực tiếp
        account.setPasswordHash(passwordEncoder.encode(request.password()));

        account = accountRepository.save(account);

        // Bước 6: Chuyển Entity -> DTO trả về
        return AccountResponse.from(account);
    }
}
