// Cloudflare Pages Function: POST /api/register
// Handles registration & revisions, uploads photos to R2, and saves/updates submission in D1

export async function onRequestPost(context) {
  const { request, env } = context;
  const db = env.DB || env.voucher_db;
  const bucket = env.BUCKET || env.voucher_photos;

  try {
    const body = await request.json();
    const {
      existingSubmissionId,
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

    const now = new Date();
    let submissionId = existingSubmissionId;

    if (!submissionId) {
      const dateStr = now.toISOString().slice(0, 10).replace(/-/g, "");
      const randomSuffix = Math.floor(1000 + Math.random() * 9000);
      submissionId = `HR-${dateStr}-${randomSuffix}`;
    }

    // Upload images to Cloudflare R2 Bucket if binding exists and if base64 image provided
    let receiptUrl = `/api/image/receipts/${submissionId}_receipt.jpg`;
    let voucherUrl = `/api/image/vouchers/${submissionId}_voucher.jpg`;

    if (bucket) {
      try {
        if (receiptImageBase64.startsWith("data:")) {
          const receiptKey = `receipts/${submissionId}_receipt.jpg`;
          const receiptBuffer = decodeBase64Image(receiptImageBase64);
          await bucket.put(receiptKey, receiptBuffer, {
            httpMetadata: { contentType: "image/jpeg" }
          });
        }

        if (voucherImageBase64.startsWith("data:")) {
          const voucherKey = `vouchers/${submissionId}_voucher.jpg`;
          const voucherBuffer = decodeBase64Image(voucherImageBase64);
          await bucket.put(voucherKey, voucherBuffer, {
            httpMetadata: { contentType: "image/jpeg" }
          });
        }
      } catch (r2PutErr) {
        console.warn("R2 Put Error:", r2PutErr);
      }
    }

    // Save or Update Record in Cloudflare D1 Database if binding exists
    if (db) {
      try {
        // Fallback: If no R2 bucket, store base64 in DB so image route can decode on demand
        const dbReceiptUrl = bucket ? receiptUrl : receiptImageBase64;
        const dbVoucherUrl = bucket ? voucherUrl : voucherImageBase64;

        if (existingSubmissionId) {
          await db.prepare(`
            UPDATE submissions
            SET customer_name = ?, customer_phone = ?, category = ?, sub_category = ?,
                model_code = ?, purchase_date = ?, purchase_amount_thb = ?,
                receipt_photo_url = ?, voucher_photo_url = ?, staff_name = ?, staff_emp_id = ?,
                voucher_status = 'pending', admin_remark = 'แก้ไขและส่งข้อมูลใหม่แล้ว'
            WHERE submission_id = ?
          `).bind(
            customerName,
            customerPhone,
            category,
            subCategory,
            modelCode,
            purchaseDate,
            parseFloat(purchaseAmount),
            dbReceiptUrl,
            dbVoucherUrl,
            staffName || "พนักงานประจำสาขา",
            staffId || "-",
            existingSubmissionId
          ).run();
        } else {
          await db.prepare(`
            INSERT INTO submissions (
              submission_id, store_id, campaign_id, customer_name, customer_phone,
              category, sub_category, model_code, purchase_date, purchase_amount_thb,
              receipt_photo_url, voucher_photo_url, staff_name, staff_emp_id, voucher_status, voucher_code
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', ?)
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
            dbReceiptUrl,
            dbVoucherUrl,
            staffName || "พนักงานประจำสาขา",
            staffId || "-",
            submissionId
          ).run();
        }
      } catch (dbErr) {
        console.warn("D1 Insert/Update Error:", dbErr);
      }
    }

    return new Response(JSON.stringify({
      success: true,
      submissionId,
      voucherCode: submissionId,
      receiptUrl,
      voucherUrl,
      status: "pending",
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
