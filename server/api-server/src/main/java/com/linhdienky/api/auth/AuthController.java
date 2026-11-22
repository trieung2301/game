package com.linhdienky.api.auth;

import com.linhdienky.api.account.dto.AccountResponse;
import com.linhdienky.api.auth.dto.RegisterRequest;
import com.linhdienky.api.common.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

/**
 * Các API xác thực. Đường dẫn đầy đủ: http://localhost:8080/api/auth/...
 *
 * @RestController   : class nhận HTTP request, trả về JSON
 * @RequestMapping   : tiền tố đường dẫn chung cho cả class
 */
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /**
     * POST /api/auth/register
     *
     * @RequestBody : đọc JSON trong body request -> chuyển thành RegisterRequest
     * @Valid       : chạy các kiểm tra @NotBlank, @Size... trong RegisterRequest
     * @ResponseStatus(CREATED): trả HTTP 201 (tạo mới thành công) thay vì 200
     */
    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AccountResponse> register(@Valid @RequestBody RegisterRequest request) {
        AccountResponse response = authService.register(request);
        return ApiResponse.ok(response);
    }
}
