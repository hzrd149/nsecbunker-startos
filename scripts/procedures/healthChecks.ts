import { types as T, healthUtil } from "../deps.ts";

export const health: T.ExpectedExports.health = {
  "admin-ui": healthUtil.checkWebUrl("http://nsecbunker.embassy:3000/"),
};
