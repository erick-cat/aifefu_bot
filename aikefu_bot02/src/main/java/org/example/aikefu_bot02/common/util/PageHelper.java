package org.example.aikefu_bot02.common.util;

/**
 * 简单分页（MyBatis-Plus 3.5+ 分页插件与本项目依赖组合未启用时，使用 count + LIMIT）
 */
public final class PageHelper {

	private PageHelper() {
	}

	public static long clampCurrent(long current) {
		return current < 1 ? 1 : current;
	}

	public static long clampSize(long size) {
		if (size < 1) {
			return 10;
		}
		return Math.min(size, 100);
	}

	public static String limitSql(long current, long size) {
		long offset = (current - 1) * size;
		return "LIMIT " + offset + "," + size;
	}
}
