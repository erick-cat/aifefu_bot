package org.example.aikefu_bot02.common.result;

import io.swagger.v3.oas.annotations.media.Schema;

import java.io.Serializable;
import java.util.List;

/**
 * 分页数据
 */
@Schema(description = "分页结果")
public class PageResult<T> implements Serializable {

	private static final long serialVersionUID = 1L;

	@Schema(description = "数据列表")
	private List<T> records;
	@Schema(description = "总条数")
	private long total;
	@Schema(description = "当前页")
	private long current;
	@Schema(description = "每页条数")
	private long size;

	public static <T> PageResult<T> of(List<T> records, long total, long current, long size) {
		PageResult<T> r = new PageResult<>();
		r.setRecords(records);
		r.setTotal(total);
		r.setCurrent(current);
		r.setSize(size);
		return r;
	}

	public List<T> getRecords() {
		return records;
	}

	public void setRecords(List<T> records) {
		this.records = records;
	}

	public long getTotal() {
		return total;
	}

	public void setTotal(long total) {
		this.total = total;
	}

	public long getCurrent() {
		return current;
	}

	public void setCurrent(long current) {
		this.current = current;
	}

	public long getSize() {
		return size;
	}

	public void setSize(long size) {
		this.size = size;
	}
}
