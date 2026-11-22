package com.linhdienky.api.common;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.dao.DataIntegrityViolationException;

/**
 * Bắt MỌI lỗi ném ra từ Controller/Service rồi đổi thành JSON ApiResponse.
 * Nhờ vậy Controller không cần viết try/catch.
 *
 * @RestControllerAdvice : áp dụng cho tất cả Controller
 *                       @ExceptionHandler(X) : method này xử lý khi có lỗi kiểu
 *                       X
 * @Slf4j : Lombok tạo sẵn biến "log" để ghi log
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /** 1. Lỗi nghiệp vụ do mình chủ động ném (trùng username, sai mật khẩu...) */
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusiness(BusinessException ex) {
        ErrorCode code = ex.getErrorCode();
        return ResponseEntity
                .status(code.getStatus())
                .body(ApiResponse.error(code.name(), code.getMessage()));
    }

    /** Trùng dữ liệu do DB chặn (2 người đăng ký cùng lúc cùng username) */
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleConflict(DataIntegrityViolationException ex) {
        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(ApiResponse.error("DUPLICATE", "Dữ liệu đã tồn tại"));
    }

    /**
     * 2. Lỗi validate (@NotBlank, @Size, @Email... trong Request bị vi phạm).
     * Lấy thông báo của lỗi ĐẦU TIÊN để trả về, ví dụ: "username: không được để
     * trống"
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
                .findFirst()
                .map(err -> err.getField() + ": " + err.getDefaultMessage())
                .orElse(ErrorCode.VALIDATION_ERROR.getMessage());
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(ErrorCode.VALIDATION_ERROR.name(), message));
    }

    /**
     * 3. Mọi lỗi KHÔNG lường trước (bug, mất kết nối DB...).
     * Ghi log đầy đủ để dev sửa, nhưng chỉ trả thông báo chung cho client
     * (không lộ chi tiết lỗi ra ngoài -> bảo mật).
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleUnexpected(Exception ex) {
        log.error("Lỗi không mong đợi", ex);
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error(ErrorCode.INTERNAL_ERROR.name(), ErrorCode.INTERNAL_ERROR.getMessage()));
    }
}
