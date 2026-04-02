<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  fetchShopProductPage,
  createShopProduct,
  updateShopProduct,
  deleteShopProduct,
} from '@/api/admin'
import { cellText } from '@/utils/display'

const loading = ref(false)
const rows = ref<Record<string, unknown>[]>([])
const total = ref(0)
const query = reactive({ current: 1, size: 10, name: '', status: undefined as number | undefined })

const dialog = ref(false)
const editingId = ref<number | null>(null)
const form = reactive({
  name: '',
  specs: '',
  price: 0,
  stock: 0,
  imageUrl: '',
  type: '',
  status: 0,
})

async function load() {
  loading.value = true
  try {
    const res = await fetchShopProductPage({
      current: query.current,
      size: query.size,
      name: query.name.trim() || undefined,
      status: query.status,
    })
    rows.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function openCreate() {
  editingId.value = null
  Object.assign(form, {
    name: '',
    specs: '',
    price: 0,
    stock: 0,
    imageUrl: '',
    type: '',
    status: 0,
  })
  dialog.value = true
}

function openEdit(row: Record<string, unknown>) {
  editingId.value = row.id as number
  Object.assign(form, {
    name: String(row.name ?? ''),
    specs: String(row.specs ?? ''),
    price: Number(row.price ?? 0),
    stock: Number(row.stock ?? 0),
    imageUrl: String(row.imageUrl ?? ''),
    type: String(row.type ?? ''),
    status: Number(row.status ?? 0),
  })
  dialog.value = true
}

async function save() {
  const body = {
    name: form.name,
    specs: form.specs || null,
    price: form.price,
    stock: form.stock,
    imageUrl: form.imageUrl || null,
    type: form.type || null,
    status: form.status,
  }
  if (editingId.value != null) {
    await updateShopProduct(editingId.value, body)
    ElMessage.success('已更新')
  } else {
    await createShopProduct(body)
    ElMessage.success('已创建')
  }
  dialog.value = false
  await load()
}

async function remove(row: Record<string, unknown>) {
  await ElMessageBox.confirm('确定删除该商品？', '提示', { type: 'warning' })
  await deleteShopProduct(row.id as number)
  ElMessage.success('已删除')
  await load()
}

onMounted(load)
</script>

<template>
  <el-card shadow="never">
    <el-form :inline="true" @submit.prevent="load">
      <el-form-item label="名称">
        <el-input v-model="query.name" placeholder="可选" clearable style="width: 180px" />
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="query.status" placeholder="全部" clearable style="width: 120px">
          <el-option :value="0" label="上架" />
          <el-option :value="1" label="下架" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="load">查询</el-button>
        <el-button type="success" @click="openCreate">新增商品</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="rows" border stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="72" />
      <el-table-column prop="name" label="名称" min-width="140" show-overflow-tooltip />
      <el-table-column prop="specs" label="规格" min-width="120" show-overflow-tooltip />
      <el-table-column prop="price" label="价格" width="100">
        <template #default="{ row }">{{ cellText(row.price) }}</template>
      </el-table-column>
      <el-table-column prop="stock" label="库存" width="80" />
      <el-table-column prop="type" label="类型" width="100" />
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">{{ Number(row.status) === 0 ? '上架' : '下架' }}</template>
      </el-table-column>
      <el-table-column label="操作" width="160" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openEdit(row)">编辑</el-button>
          <el-button type="danger" link @click="remove(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div style="margin-top: 16px; display: flex; justify-content: flex-end">
      <el-pagination
        v-model:current-page="query.current"
        v-model:page-size="query.size"
        :total="total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next"
        @current-change="load"
        @size-change="
          () => {
            query.current = 1
            load()
          }
        "
      />
    </div>

    <el-dialog v-model="dialog" :title="editingId != null ? '编辑商品' : '新增商品'" width="520px" destroy-on-close>
      <el-form label-width="88px">
        <el-form-item label="名称" required>
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="规格">
          <el-input v-model="form.specs" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="价格">
          <el-input-number v-model="form.price" :min="0" :precision="2" :step="1" />
        </el-form-item>
        <el-form-item label="库存">
          <el-input-number v-model="form.stock" :min="0" :step="1" />
        </el-form-item>
        <el-form-item label="图片URL">
          <el-input v-model="form.imageUrl" placeholder="https://..." />
        </el-form-item>
        <el-form-item label="类型">
          <el-input v-model="form.type" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :label="0">上架</el-radio>
            <el-radio :label="1">下架</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialog = false">取消</el-button>
        <el-button type="primary" @click="save">保存</el-button>
      </template>
    </el-dialog>
  </el-card>
</template>
