// Cloudflare Pages Function: /api/dimensions
// Returns Store dimensions, Model dimensions, and Campaigns from D1

export async function onRequestGet(context) {
  const { env } = context;

  if (!env.DB) {
    return new Response(JSON.stringify({ offline: true }), {
      headers: { "Content-Type": "application/json" }
    });
  }

  try {
    const [storesResult, modelsResult, campaignsResult] = await Promise.all([
      env.DB.prepare("SELECT * FROM dimension_store WHERE is_active = 1").all(),
      env.DB.prepare("SELECT model_code, category, sub_category FROM dimension_model WHERE is_active = 1").all(),
      env.DB.prepare("SELECT * FROM campaigns WHERE is_active = 1").all()
    ]);

    return new Response(JSON.stringify({
      stores: storesResult.results || [],
      models: modelsResult.results || [],
      campaigns: campaignsResult.results || []
    }), {
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": "public, max-age=60"
      }
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
}
