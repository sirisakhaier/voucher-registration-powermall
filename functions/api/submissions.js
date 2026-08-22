// Cloudflare Pages Function: /api/submissions
// GET: Query submissions with filtering by store or campaign
// PUT: Update voucher status (issued, rejected, redeemed)
// DELETE: Delete individual submission or reset all submissions

export async function onRequestGet(context) {
  const { request, env } = context;
  const db = env.DB || env.voucher_db;
  const url = new URL(request.url);
  const storeId = url.searchParams.get("store_id");
  const campaignId = url.searchParams.get("campaign_id");

  if (!db) {
    return new Response(JSON.stringify({ submissions: [] }), {
      headers: { "Content-Type": "application/json" }
    });
  }

  try {
    let query = `
      SELECT 
        s.*,
        st.store_name_th as store_name,
        c.name_th as campaign_name,
        c.reward_name,
        c.reward_value_thb as reward_value
      FROM submissions s
      LEFT JOIN dimension_store st ON s.store_id = st.store_id
      LEFT JOIN campaigns c ON s.campaign_id = c.campaign_id
      WHERE 1=1
    `;
    const params = [];

    if (storeId) {
      query += " AND s.store_id = ?";
      params.push(storeId);
    }

    if (campaignId) {
      query += " AND s.campaign_id = ?";
      params.push(campaignId);
    }

    query += " ORDER BY s.submitted_at DESC LIMIT 500";

    const { results } = await db.prepare(query).bind(...params).all();

    return new Response(JSON.stringify({ submissions: results || [] }), {
      headers: { "Content-Type": "application/json" }
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
}

export async function onRequestPut(context) {
  const { request, env } = context;
  const db = env.DB || env.voucher_db;
  if (!db) return new Response(JSON.stringify({ success: true }));

  try {
    const { submissionId, status, remark } = await request.json();
    if (!submissionId || !status) {
      return new Response(JSON.stringify({ error: "Missing submissionId or status" }), { status: 400 });
    }

    await db.prepare(`
      UPDATE submissions
      SET voucher_status = ?, admin_remark = ?
      WHERE submission_id = ?
    `).bind(status, remark || null, submissionId).run();

    return new Response(JSON.stringify({ success: true }));
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
}

export async function onRequestDelete(context) {
  const { request, env } = context;
  const db = env.DB || env.voucher_db;
  const bucket = env.BUCKET || env.voucher_photos;

  try {
    const body = await request.json();
    const { submissionId, confirmation } = body;

    // Case 1: Delete all submissions
    if (confirmation === "CONFIRM-RESET") {
      if (db) {
        await db.prepare("DELETE FROM submissions").run();
      }

      if (bucket) {
        try {
          const listed = await bucket.list();
          for (const obj of listed.objects) {
            await bucket.delete(obj.key);
          }
        } catch (r2DelAllErr) {
          console.warn("R2 batch delete notice:", r2DelAllErr);
        }
      }

      return new Response(JSON.stringify({
        success: true,
        message: "All submissions deleted successfully"
      }), {
        headers: { "Content-Type": "application/json" }
      });
    }

    // Case 2: Delete individual submission by ID
    if (submissionId) {
      if (db) {
        await db.prepare("DELETE FROM submissions WHERE submission_id = ?").bind(submissionId).run();
      }

      if (bucket) {
        try {
          await bucket.delete(`receipts/${submissionId}_receipt.jpg`);
          await bucket.delete(`vouchers/${submissionId}_voucher.jpg`);
        } catch (r2DelErr) {
          console.warn("R2 delete single error:", r2DelErr);
        }
      }

      return new Response(JSON.stringify({
        success: true,
        message: `Submission ${submissionId} deleted successfully`
      }), {
        headers: { "Content-Type": "application/json" }
      });
    }

    return new Response(JSON.stringify({ error: "Missing submissionId or confirmation code" }), {
      status: 400,
      headers: { "Content-Type": "application/json" }
    });

  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
}
