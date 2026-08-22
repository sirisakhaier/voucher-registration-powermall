// Cloudflare Pages Function: POST /api/register
// Handles registration, uploads 2 photos to R2, and saves submission to D1

export async function onRequestPost(context) {
  const { request, env } = context;

  try {
    const body = await request.json();
    const {
      storeId,
      campaignId,
      customerName,
      customerPhone,
      category,
      subCategory,
      modelCode,
      purchaseDate,
      purchaseAmount,
      receiptImageBase64,
      voucherImageBase64,
      staffName,
      staffId
    } = body;

    // Validate required fields
    if (!storeId || !campaignId || !customerName || !customerPhone || !category || !subCategory || !modelCode || !purchaseDate || !purchaseAmount) {
      return new Response(JSON.stringify({ error: "Missing required registration fields" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }

    if (!receiptImageBase64 || !voucherImageBase64) {
      return new Response(JSON.stringify({ error: "Both Receipt and Voucher photos are required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" }
      });
    }

    // Generate unique Voucher Reference Code: HR-YYYYMMDD-XXXX
    const now = new Date();
    const dateStr = now.toISOString().slice(0, 10).replace(/-/g, "");
    const randomSuffix = Math.floor(1000 + Math.random() * 9000);
    const submissionId = `HR-${dateStr}-${randomSuffix}`;

    // Upload images to Cloudflare R2 Bucket if binding exists
    let receiptUrl = receiptImageBase64;
    let voucherUrl = voucherImageBase64;

    if (env.BUCKET) {
      // 1. Upload Receipt Photo
      const receiptKey = `receipts/${submissionId}_receipt.jpg`;
      const receiptBuffer = decodeBase64Image(receiptImageBase64);
      await env.BUCKET.put(receiptKey, receiptBuffer, {
        httpMetadata: { contentType: "image/jpeg" }
      });
      receiptUrl = `/api/image/${receiptKey}`;

      // 2. Upload Voucher Photo
      const voucherKey = `vouchers/${submissionId}_voucher.jpg`;
      const voucherBuffer = decodeBase64Image(voucherImageBase64);
      await env.BUCKET.put(voucherKey, voucherBuffer, {
        httpMetadata: { contentType: "image/jpeg" }
      });
      voucherUrl = `/api/image/${voucherKey}`;
    }

    // Save Record to Cloudflare D1 Database if binding exists
    if (env.DB) {
      await env.DB.prepare(`
        INSERT INTO submissions (
          submission_id, store_id, campaign_id, customer_name, customer_phone,
          category, sub_category, model_code, purchase_date, purchase_amount_thb,
          receipt_photo_url, voucher_photo_url, staff_name, staff_emp_id, voucher_status, voucher_code
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'issued', ?)
      `).bind(
        submissionId,
        storeId,
        campaignId,
        customerName,
        customerPhone,
        category,
        subCategory,
        modelCode,
        purchaseDate,
        parseFloat(purchaseAmount),
        receiptUrl,
        voucherUrl,
        staffName || "พนักงานประจำสาขา",
        staffId || "-",
        submissionId
      ).run();
    }

    return new Response(JSON.stringify({
      success: true,
      submissionId,
      voucherCode: submissionId,
      receiptUrl,
      voucherUrl,
      timestamp: now.toISOString()
    }), {
      status: 200,
      headers: { "Content-Type": "application/json" }
    });

  } catch (error) {
    return new Response(JSON.stringify({
      error: error.message || "Failed to process registration"
    }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
}

function decodeBase64Image(dataUrl) {
  const matches = dataUrl.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/);
  const base64Data = matches ? matches[2] : dataUrl;
  const binaryString = atob(base64Data);
  const len = binaryString.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes.buffer;
}
