package org.example.aikefu_bot02.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * 简易 JWT（生产请改密钥并配合网关/过滤器校验）
 */
@Component
public class JwtUtil {

	private static final String CLAIM_TYP = "typ";
	private static final String TYP_CUSTOMER = "cust";

	@Value("${app.jwt.secret:aikefu-admin-jwt-secret-key-min-32-chars-long!!}")
	private String secret;

	private static final long EXPIRE_MS = 7L * 24 * 60 * 60 * 1000;

	private SecretKey key() {
		byte[] bytes = secret.getBytes(StandardCharsets.UTF_8);
		if (bytes.length < 32) {
			byte[] padded = new byte[32];
			System.arraycopy(bytes, 0, padded, 0, Math.min(bytes.length, 32));
			return Keys.hmacShaKeyFor(padded);
		}
		return Keys.hmacShaKeyFor(bytes);
	}

	public String generate(Long adminId, String username) {
		Date now = new Date();
		return Jwts.builder()
				.subject(String.valueOf(adminId))
				.claim("username", username)
				.issuedAt(now)
				.expiration(new Date(now.getTime() + EXPIRE_MS))
				.signWith(key())
				.compact();
	}

	/**
	 * C 端用户 JWT，带 {@code typ=cust}，与管理员 token 区分。
	 */
	public String generateForCustomer(Long customerId, String username) {
		Date now = new Date();
		return Jwts.builder()
				.subject(String.valueOf(customerId))
				.claim("username", username)
				.claim(CLAIM_TYP, TYP_CUSTOMER)
				.issuedAt(now)
				.expiration(new Date(now.getTime() + EXPIRE_MS))
				.signWith(key())
				.compact();
	}

	/**
	 * 从 {@code Authorization: Bearer ...} 解析 C 端用户 ID；非法或非 C 端 token 返回 null。
	 */
	public Long parseCustomerIdFromBearer(String authorizationHeader) {
		if (authorizationHeader == null || authorizationHeader.length() < 7
				|| !authorizationHeader.regionMatches(true, 0, "Bearer ", 0, 7)) {
			return null;
		}
		String token = authorizationHeader.substring(7).trim();
		if (token.isEmpty()) {
			return null;
		}
		try {
			Claims claims = Jwts.parser()
					.verifyWith(key())
					.build()
					.parseSignedClaims(token)
					.getPayload();
			if (!TYP_CUSTOMER.equals(claims.get(CLAIM_TYP))) {
				return null;
			}
			return Long.parseLong(claims.getSubject());
		} catch (Exception e) {
			return null;
		}
	}
}
