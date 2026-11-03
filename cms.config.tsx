import { config, entity, role, text } from "@cms/config";
import { path } from "@cms/paths";
import { shopify } from "@cms/shopify";
import { s3 } from "@cms/storage-s3";
import { smtp } from "@cms/email-smtp";

export const shop = shopify({
  store: process.env.CMS_PUBLIC_SHOPIFY_STORE_NAME,
  admin: {
    clientId: process.env.SHOPIFY_CLIENT_ID,
    clientSecret: process.env.SHOPIFY_CLIENT_SECRET,
  },
  // Pneuma Hydrogen channel — change if your channel name differs in admin
  channel: "Hydrogen",
});

const productPage = entity("product_page", {
  versions: true,
  fields: [
    shop.product("product", { required: true, unique: true, fillTitle: true }),
    text("title", { required: true }),
    path("path", { source: (doc) => `/products/${doc.product?.handle ?? ""}` }),
  ],
  hooks: {
    beforeDraftSave: shop.assertUnique,
    beforePublish: shop.assertUnique,
  },
});

const adminRole = role("admin", { isAdmin: true });

export default config({
  storage: s3({
    bucket: process.env.S3_BUCKET,
    region: process.env.S3_REGION,
    accessKeyId: process.env.S3_ACCESS_KEY_ID,
    secretAccessKey: process.env.S3_SECRET_ACCESS_KEY,
    endpoint: process.env.S3_ENDPOINT,
  }),
  email: smtp({
    from: process.env.EMAIL_SENDER ?? "noreply@pneuma.local",
    hostname: process.env.SMTP_HOSTNAME ?? "localhost",
    port: Number(process.env.SMTP_PORT ?? 1025),
    username: process.env.SMTP_USERNAME,
    password: process.env.SMTP_PASSWORD,
    encryption: "plaintext-insecure", // Mailpit on 1025
  }),
  entities: [productPage],
  roles: [adminRole],
  plugins: [shop],
  admin: {
    title: "Pneuma CMS",
  },
});
