// Cloudflare Pages Function: /api/image/[[path]]
// Serves images stored in Cloudflare R2 Bucket securely

export async function onRequestGet(context) {
  const { params, env } = context;
  const path = Array.isArray(params.path) ? params.path.join("/") : params.path;

  if (!env.BUCKET || !path) {
    return new Response("Not found", { status: 404 });
  }

  try {
    const object = await env.BUCKET.get(path);

    if (!object) {
      return new Response("Image not found in storage", { status: 404 });
    }

    const headers = new Headers();
    object.writeHttpMetadata(headers);
    headers.set("etag", object.httpEtag);
    headers.set("Cache-Control", "public, max-age=31536000, immutable");

    return new Response(object.body, { headers });
  } catch (err) {
    return new Response("Error fetching image: " + err.message, { status: 500 });
  }
}
