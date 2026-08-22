// Cloudflare Pages Function: /api/image/[[path]]
// Serves images stored in Cloudflare R2 Bucket, with fallback to D1 database

export async function onRequestGet(context) {
  const { params, env } = context;
  const db = env.DB || env.voucher_db;
  const bucket = env.BUCKET || env.voucher_photos;
  const path = Array.isArray(params.path) ? params.path.join("/") : params.path;

  if (!path) {
    return new Response("Not found", { status: 404 });
  }

  // 1. Try fetching from Cloudflare R2 Bucket first
  if (bucket) {
    try {
      const cleanKey = path.replace(/^\/+/, "");
      const object = await bucket.get(cleanKey);

      if (object) {
        const headers = new Headers();
        headers.set("Content-Type", "image/jpeg");
        if (object.httpMetadata && object.httpMetadata.contentType) {
          headers.set("Content-Type", object.httpMetadata.contentType);
        }
        if (object.httpEtag) headers.set("etag", object.httpEtag);
        headers.set("Cache-Control", "public, max-age=31536000, immutable");

        return new Response(object.body, { headers });
      }
    } catch (r2Err) {
      console.warn("R2 fetch error, trying D1 fallback:", r2Err);
    }
  }

  // 2. Fallback: Lookup in Cloudflare D1 database
  if (db) {
    try {
      const filename = path.split("/").pop() || "";
      const match = filename.match(/(HR-[0-9]+-[0-9]+)/i);

      if (match) {
        const subId = match[1];
        const isVoucher = filename.toLowerCase().includes("voucher");

        const row = await db.prepare(
          "SELECT receipt_photo_url, voucher_photo_url FROM submissions WHERE submission_id = ?"
        ).bind(subId).first();

        if (row) {
          const imgStr = isVoucher ? row.voucher_photo_url : row.receipt_photo_url;
          if (imgStr && imgStr.startsWith("data:")) {
            const buffer = decodeBase64Image(imgStr);
            return new Response(buffer, {
              headers: {
                "Content-Type": "image/jpeg",
                "Cache-Control": "public, max-age=86400"
              }
            });
          }
        }
      }
    } catch (dbErr) {
      console.warn("D1 fallback lookup error:", dbErr);
    }
  }

  return new Response("Image not found in storage", {
    status: 404,
    headers: { "Content-Type": "text/plain; charset=utf-8" }
  });
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
