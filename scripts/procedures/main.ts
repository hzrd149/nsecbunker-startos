import { types as T, util } from "../deps.ts";

export const main = async (effects: T.Effects) => {
  await effects.runDaemon({ command: "docker_entrypoint.sh", args: [] }).wait();
  return util.ok;
};
