package com.linhdienky.api.common;

import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * Định dạng trả về THỐNG NHẤT cho mọi API.
 *
 * Thành công:  { "success": true,  "data": {...} }
 * Thất bại:    { "success": false, "code": "USERNAME_TAKEN", "message": "Tên đăng nhập đã tồn tại" }
 *
 * Client (Unity, React) chỉ cần kiểm tra "success" là biết kết quả.
 *
 * "record" = class chỉ chứa dữ liệu, Java tự sinh constructor, getter, equals, toString.
 */
@JsonInclude(JsonInclude.Include.NON_NULL)   // Field nào null thì không xuất hiện trong JSON
public record ApiResponse<T>(
        boolean success,
        T data,          // dữ liệu trả về khi thành công
        String code,     // mã lỗi khi thất bại
        String message   // thông báo lỗi cho người dùng
) {

    /** Trả về thành công kèm dữ liệu. Dùng: return ApiResponse.ok(account); */
    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(true, data, null, null);
    }

    /** Trả về thành công không kèm dữ liệu (ví dụ: đăng xuất). */
    public static ApiResponse<Void> ok() {
        return new ApiResponse<>(true, null, null, null);
    }

    /** Trả về thất bại. Dùng trong GlobalExceptionHandler. */
    public static <T> ApiResponse<T> error(String code, String message) {
        return new ApiResponse<>(false, null, code, message);
    }
}
